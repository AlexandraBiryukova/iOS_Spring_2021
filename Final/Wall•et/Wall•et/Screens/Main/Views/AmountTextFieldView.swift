//
//  AmountTextFieldView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct AmountTextFieldView: View {
    @Binding var value: Double
    var placeholder: String = L10n.amountTextFieldPlaceHolder
    @State var isEditing = false
    
    init(amount: Binding<Double>) {
        _value = amount
    }
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    private var formattedText: Binding<String> {
        Binding<String> (
            get: {
                guard value != 0 else { return "" }
                return formatter.string(from: .init(value: value), configurator: .init(maximumFractionDigits: 2)) ?? String(value) },
            set: { text in
                self.value = formatter.number(from: text.filter { $0.isNumber }, configurator: .init(maximumFractionDigits: 2))?.doubleValue ?? 0
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
                if !formattedText.wrappedValue.isEmpty {
                    Text("₸")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.trailing, 16)
                }
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

struct AmountTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        AmountTextFieldView(amount: .constant(0))
            .previewDevice("iPhone 11 Pro Max")
    }
}
