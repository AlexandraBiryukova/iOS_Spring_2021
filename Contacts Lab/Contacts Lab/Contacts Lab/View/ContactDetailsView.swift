//
//  ContactDetailsView.swift
//  Contacts Lab
//
//  Created by Alexandra Biryukova on 2/18/21.
//

import SwiftUI

struct ContactDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let contact: Contact
    private let completion: (Contact) -> ()
    
    init(contact: Contact, completion: @escaping(Contact) -> ()) {
        self.contact = contact
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ContactView(contact: contact, viewState: .details)
            Spacer()
            Button("Call") {
                if let url = URL(string: "tel://\(contact.phoneNumber)") {
                    UIApplication.shared.open(url)
                }
            }.foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 32)
            .background(Color.green)
            Button("Delete") {
                completion(contact)
                self.presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 32)
            .background(Color.red)
        }.navigationTitle("Contact Info")
        .padding(.top, 24)
        .padding(.horizontal, 24)
    }
}
