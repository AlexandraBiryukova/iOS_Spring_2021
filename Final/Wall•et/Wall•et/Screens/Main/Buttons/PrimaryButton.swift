//
//  PrimaryButton.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let color: ColorAsset
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color(Assets.white.color))
            .font(.system(size: 18, weight: .semibold, design: .default))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(color.color.withAlphaComponent(configuration.isPressed ? 0.8 : 1)) )
            .cornerRadius(8)
    }
}

struct PrimaryButton: View {
    let title: String
    let color: ColorAsset
    let image: String?
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        Button(action: action, label: {
            HStack(alignment: .center) {
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Text(title)
            }
        })
        .buttonStyle(PrimaryButtonStyle(color: color))
        .opacity(isEnabled ? 1 : 0.8)
    }
}
