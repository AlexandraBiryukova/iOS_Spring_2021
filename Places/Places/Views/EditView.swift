//
//  EditView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/22/21.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var name: String
    @State var message: String
    
    var body: some View {
        VStack(spacing: 32) {
            TextField("Enter title", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 32)
                .zIndex(1)
            TextField("Enter subtitle", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 32)
                .zIndex(1)
            Spacer()
        }.navigationBarTitle("Edit")
        .padding(.top, 24)
        .navigationBarItems(leading:
                                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                    Text("Cancel")
                                }, trailing:
                                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                        Text("Done")
                                    })
    }
}
