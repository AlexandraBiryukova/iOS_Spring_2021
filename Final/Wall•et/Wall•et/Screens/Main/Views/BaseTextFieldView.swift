//
//  BaseTextFieldView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct BaseTextFieldView: View {
    @Binding var text: String
    var placeholder: String
    @State var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !$text.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14))
                    .foregroundColor(Color(Assets.gray2.color))
            }
            TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                self.isEditing = isEditing
            }, onCommit: {})
            .padding(.horizontal)
            .font(.system(size: 16))
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

struct BaseTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        BaseTextFieldView(text: .constant(""), placeholder: "Имя")
            .previewDevice("iPhone 11 Pro Max")
    }
}
