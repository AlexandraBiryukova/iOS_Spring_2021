//
//  PhoneNumberTextFieldView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/11/21.
//

import SwiftUI

struct PhoneNumberTextFieldView: View {
    @Binding var value: String
    var placeholder: String = L10n.phoneNumberTextFieldPlaceholder
    @State var isEditing = false
    
    init(value: Binding<String>) {
        _value = value
    }
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    private var formattedText: Binding<String> {
        Binding<String> (
            get: {
                return formatter.formattedPhoneNumber(from: value) ?? value
            },
            set: { text in
                self.value = formatter.formattedPhoneNumber(from: text) ?? text
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !formattedText.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14))
                    .foregroundColor(Color(Assets.gray2.color))
            }
            HStack(spacing: 12) {
                TextField(placeholder, text: formattedText, onEditingChanged: { isEditing in
                    self.isEditing = isEditing
                }, onCommit: {})
                .padding()
                .keyboardType(.numberPad)
                .font(.system(size: 16))
                .frame(height: 48)
            }
            .frame(height: 48)
            .foregroundColor(Color(Assets.black.color))
            .accentColor(Color(Assets.primary.color))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color((isEditing ? Assets.primary : Assets.divider).color), lineWidth: 1)
            )
        }
    }
}

struct PhoneNumberTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberTextFieldView(value: .constant(""))
            .previewDevice("iPhone 11 Pro Max")
    }
}
