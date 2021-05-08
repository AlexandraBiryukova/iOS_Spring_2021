//
//  SecondaryButton.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color(Assets.secondary.color))
            .font(.system(size: 18, weight: .semibold, design: .default))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color((configuration.isPressed ? Assets.secondary : Assets.white).color).opacity(0.5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(Assets.secondary.color), lineWidth: 1)
            )
    }
}

struct SecondaryButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text(title)
            }
        })
        .buttonStyle(SecondaryButtonStyle())
        .padding(.horizontal)
    }
}
