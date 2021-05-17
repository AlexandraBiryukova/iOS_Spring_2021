//
//  ImagePickerService.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import Foundation
import Photos
import SwiftUI
import UIKit

final class ImagePickerService: NSObject {
    func presentImagePickerSourceTypesSelect(completion: @escaping (UIImagePickerController.SourceType?) -> Void) -> UIAlertController {
        let sourceTypes: [UIImagePickerController.SourceType] = [.camera, .photoLibrary]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sourceTypes.forEach { type in
            guard UIImagePickerController.isSourceTypeAvailable(type),
                  let title = title(for: type) else { return }
            
            alertController.addAction(UIAlertAction(title: title, style: .default) { _ in
                completion(type)
            })
        }
        alertController.addAction(UIAlertAction(title: L10n.coreCancel, style: .cancel) { _ in
            completion(nil)
        })
        return alertController
    }
    
    func checkPermission(for sourceType: UIImagePickerController.SourceType, completion: @escaping (Bool) -> Void) {
        switch sourceType {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { isPermitted in
                DispatchQueue.main.async {
                    completion(isPermitted)
                }
            }
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        default:
            completion(false)
        }
    }
    
    func presentPermissionDeniedAlert(sourceType: UIImagePickerController.SourceType, completion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: permissionDeniedAlertTitle(from: sourceType), message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.coreGo, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
            completion()
        })
        alertController.addAction(UIAlertAction(title: L10n.coreCancel, style: .cancel) { _ in
            completion()
        })
        return alertController
    }
    
    func title(for sourceType: UIImagePickerController.SourceType) -> String? {
        switch sourceType {
        case .camera:
            return L10n.imagePickerServiceCamera
        case .photoLibrary:
            return L10n.imagePickerServicePhotoLibrary
        default:
            return nil
        }
    }
    
    private func permissionDeniedAlertTitle(from sourceType: UIImagePickerController.SourceType) -> String? {
        switch sourceType {
        case .camera:
            return L10n.imagePickerServiceCameraPermissionDeniedTitle
        case .photoLibrary:
            return L10n.imagePickerServicePhotoLibraryPermissionDeniedTitle
        default:
            return nil
        }
    }
}
