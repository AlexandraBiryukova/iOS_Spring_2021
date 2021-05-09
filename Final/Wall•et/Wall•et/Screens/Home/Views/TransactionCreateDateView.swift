//
//  TransactionCreateDateView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct TransactionCreateDateView: View {
    enum DateType {
        case time, date
    }
    @Binding var createDate: Date
    let type: DateType
    
    var body: some View {
        ZStack {
            HStack(spacing: 4) {
                Text(type == .date ? "Дата транзакции" : "Время транзакции")
                    .font(.system(size: 16))
                    .foregroundColor(Color(Assets.black.color))
                DatePicker("", selection: $createDate, displayedComponents: type == .time ? .hourAndMinute : .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .environment(\.locale, AppLanguage.current.locale)
            }
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
    }
}
