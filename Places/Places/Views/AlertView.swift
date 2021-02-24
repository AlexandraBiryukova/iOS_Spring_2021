//
//  AlertView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/21/21.
//

import MapKit
import SwiftUI

struct AlertControlView: UIViewControllerRepresentable {
    @Binding var newLocationCoordinate: CLLocationCoordinate2D?
    
    let completion: (String, String) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        guard context.coordinator.alert == nil else { return }
        let alert = UIAlertController(title: "Add place", message: "Fill all the fields", preferredStyle: .alert)
        context.coordinator.alert = alert
        ["Enter title", "Enter subtitle"].enumerated().forEach { index, content in
            alert.addTextField { textField in
                textField.tag = index
                textField.placeholder = content
            }
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .default) { _ in
            context.coordinator.alert = nil
            completion(alert.textFields?.first?.text ?? "",  alert.textFields?.last?.text ??  "")
        })
        
        if $newLocationCoordinate.wrappedValue != nil {
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> AlertCoordinator {
        return AlertCoordinator(self)
    }
}

class AlertCoordinator: NSObject {
    var alert: UIAlertController?
    var control: AlertControlView
    
    init(_ control: AlertControlView) {
        self.control = control
    }
}
