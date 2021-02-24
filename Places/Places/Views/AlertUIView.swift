//
//  AlertUIView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/24/21.
//

import SwiftUI

struct AlertUIView: View {
    @State var name: String = ""
    @State var message: String = ""
    
    private let completion: (String, String) -> Void
    
    init(completion: @escaping (String, String) -> Void) {
        self.completion = completion
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("Add place")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Fill all the fields")
                        .font(.system(size: 16, weight: .regular))
                }.padding(.top, 24)
                .foregroundColor(.black)
                VStack(spacing: 2) {
                    TextField("Enter title", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 16)
                        .foregroundColor(.black)
                        .background(Color.white)
                    TextField("Enter subtitle", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 16)
                        .zIndex(1)
                        .foregroundColor(.black)
                        .background(Color.white)
                }
                VStack(spacing:0) {
                    Divider()
                        .frame(height: 0.5)
                        .background(Color.gray.opacity(0.5))
                    Button("Add") {
                        completion(name, message)
                    }.padding(.vertical, 12)
                }
            }.background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 64)
            Spacer()
        }
        .ignoresSafeArea(.all)
        .background(Color.black.opacity(0.5))
        
    }
}

struct ContentView_Previews_Alert: PreviewProvider {
    static var previews: some View {
        AlertUIView(completion: { _ ,_ in print("")})
    }
}
