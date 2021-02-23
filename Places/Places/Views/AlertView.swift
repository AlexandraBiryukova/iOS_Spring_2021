//
//  AlertView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/21/21.
//

import MapKit
import SwiftUI

struct AlertControlView: UIViewControllerRepresentable {
    @Binding var newLocation: CLLocationCoordinate2D?
    @Binding var name: String?
    @Binding var description: String?
    
    let completion: (String, String) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        guard context.coordinator.alert == nil else { return }
        let alert = UIAlertController(title: "Add place", message: "Fill all the fields", preferredStyle: .alert)
        context.coordinator.alert = alert
        [("Enter title", name), ("Enter subtitle", description)].enumerated().forEach { index, content in
            alert.addTextField { textField in
                textField.tag = index
                textField.placeholder = content.0
                textField.text = content.1
                textField.delegate = context.coordinator
            }
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .default) { _ in
            if let titleField = alert.textFields?.first,
               let descriptionField = alert.textFields?.last {
                self.name = titleField.text ?? ""
                self.description = descriptionField.text ?? ""
            }
            alert.dismiss(animated: true) { completion(name ?? "", description ?? "") }
        })
        
        if newLocation != nil {
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: { context.coordinator.alert = nil })
            }
        }
    }
    
    func makeCoordinator() -> AlertCoordinator {
        return AlertCoordinator(self)
    }
}

class AlertCoordinator: NSObject, UITextFieldDelegate {
    var alert: UIAlertController?
    var control: AlertControlView
    
    init(_ control: AlertControlView) {
        self.control = control
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case 0:
            self.control.name = text
        default:
            self.control.description = text
        }
        return true
    }
}
