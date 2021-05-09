//
//  AlertView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import UIKit
import SwiftUI

struct AlertView: UIViewControllerRepresentable {
    @Binding var presentAlert: Bool
    let alertViewController: UIAlertController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertView>) {
        guard context.coordinator.alert == nil else { return }
        context.coordinator.alert = alertViewController
        if $presentAlert.wrappedValue {
            DispatchQueue.main.async {
                uiViewController.present(alertViewController, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> AlertCoordinator {
        return AlertCoordinator(self)
    }
}

class AlertCoordinator: NSObject {
    var alert: UIAlertController?
    var control: AlertView
    
    init(_ control: AlertView) {
        self.control = control
    }
}
