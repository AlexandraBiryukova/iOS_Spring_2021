//
//  SelectView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import SwiftUI

struct SelectView: View {
    @Binding var isSelected: Bool
    let title: String
    @State private var degrees: Double = 0
    
    init(isSelected: Binding<Bool>, title: String) {
    _isSelected = isSelected
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color(Assets.gray2.color))
            Spacer()
            Image(systemName: "chevron.up")
                .foregroundColor(Color(Assets.primary.color))
                .rotationEffect(.degrees(degrees))
            
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
        .background(Color.white)
        .animation(.easeOut)
        .onTapGesture {
            isSelected.toggle()
            degrees = degrees == 0 ? 180 : 0
        }
    }
}
