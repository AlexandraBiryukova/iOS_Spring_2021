//
//  AddContactView.swift
//  Contacts Lab
//
//  Created by Alexandra Biryukova on 2/18/21.
//

import SwiftUI

struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var contact = Contact(name: "", phoneNumber: "", gender: .male)
    private let completion: (Contact) -> ()
    
    init(completion: @escaping(Contact) -> ()) {
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 32) {
            TextField("Enter name and surname", text: $contact.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 32)
                .zIndex(1)
            TextField("Enter phone number", text: $contact.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 32)
                .zIndex(1)
            Picker("", selection: $contact.gender) {
                ForEach([Gender.male, Gender.female], id: \.self) {
                    Text($0.rawValue)
                }
            }.datePickerStyle(WheelDatePickerStyle())
            .frame(height: 80)
            .padding(.horizontal, 32)
            Spacer()
            Button("Save") {
                completion(contact)
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(contact.name.isEmpty && contact.phoneNumber.isEmpty)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 32)
            .background(buttonColor)
            .padding(.horizontal, 24)
        }.navigationTitle("New contact")
        .padding(.top, 24)
    }
    
    var buttonColor: Color {
        return contact.name.isEmpty && contact.phoneNumber.isEmpty ? .gray : .blue
    }
}
