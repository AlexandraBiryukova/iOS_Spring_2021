//
//  ImagePickerCropper.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import CropViewController
import Foundation
import SwiftUI

struct ImageCropper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCropper>) -> CropViewController {
        let viewController = CropViewController(croppingStyle: .circular, image: image)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: UIViewControllerRepresentableContext<ImageCropper>) {
        
    }
    
    func makeCoordinator() -> CropperCoordinator {
        CropperCoordinator(self)
    }
    
}

class CropperCoordinator: NSObject, UINavigationControllerDelegate, CropViewControllerDelegate {
    let parent: ImageCropper
    
    init(_ parent: ImageCropper) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
        }
        
        parent.presentationMode.wrappedValue.dismiss()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        parent.presentationMode.wrappedValue.dismiss()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        parent.presentationMode.wrappedValue.dismiss()
//        delegate?.didCropImage(self, image: image)
    }
}
