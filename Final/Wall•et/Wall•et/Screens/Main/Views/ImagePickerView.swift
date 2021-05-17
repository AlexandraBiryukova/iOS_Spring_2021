//
//  ImagePickerView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var data: Data?
    let sourceType: UIImagePickerController.SourceType?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        if let sourceType = sourceType {
            viewController.sourceType = sourceType
        }
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> PickerCoordinator {
        PickerCoordinator(self)
    }
    
}

class PickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
            parent.data = uiImage.pngData()
        }
        
        parent.presentationMode.wrappedValue.dismiss()
    }
}
