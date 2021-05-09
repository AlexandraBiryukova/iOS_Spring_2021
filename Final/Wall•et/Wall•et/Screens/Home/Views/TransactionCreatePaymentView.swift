//
//  TransactionCreatePaymentView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct TransactionCreatePaymentView: View {
    @Binding var type: TransactionType
    @State var presentActionSheet = false
    var body: some View {
        HStack(spacing: 4) {
            Text("Тип оплаты")
                .font(.system(size: 16))
                .foregroundColor(Color(Assets.black.color))
            Spacer()
            Text(type.title)
                .font(.system(size: 16))
                .foregroundColor(Color(Assets.primary.color))
            Image(systemName: "chevron.right")
                .foregroundColor(Color(Assets.primary.color))
            
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .foregroundColor(Color(Assets.black.color))
        .accentColor(Color(Assets.primary.color))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(Assets.divider.color), lineWidth: 1)
        )
        .onTapGesture {
            presentActionSheet = true
        }
        .actionSheet(isPresented: $presentActionSheet, content: {
            ActionSheet(title: Text("Выберите тип оплаты"), message: nil, buttons: [
                .default(Text(TransactionType.card.title), action: { type = .card }),
                .default(Text(TransactionType.cash.title), action: {
                    type = .cash
                }),
                .cancel {
                    presentActionSheet = false
                }
            ])
        })
    }
}
