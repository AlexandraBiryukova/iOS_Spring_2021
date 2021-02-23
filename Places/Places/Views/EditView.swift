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
    
    private let place: Place?
    private let completion: (Place?) -> Void
    
    init(place: Place?, completion: @escaping (Place?) -> Void) {
        self.place = place
        _name = State(initialValue: place?.name ?? "")
        _message = State(initialValue: place?.message ?? "")
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 32) {
            TextField("Enter title", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 64)
                .zIndex(1)
                .padding(.top, 80)
            TextField("Enter subtitle", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 64)
                .zIndex(1)
            Spacer()
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Edit")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: { self.presentationMode.wrappedValue.dismiss()
                                    completion(nil)
                                }) {
                                    Text("Cancel")
                                }, trailing:
                                    Button(action: { self.presentationMode.wrappedValue.dismiss()
                                        guard let place = place else { return }
                                        place.name = name
                                        place.message = message
                                        completion(place)
                                    }) {
                                        Text("Done")
                                    })
    }
}
