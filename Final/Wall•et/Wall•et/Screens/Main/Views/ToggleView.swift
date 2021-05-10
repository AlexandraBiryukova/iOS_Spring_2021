//
//  ToggleView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import SwiftUI

struct ToggleView: View {
    @Binding private var isEnabled: Bool
    private let title: String
    
    init(isEnabled: Binding<Bool>, title: String) {
        _isEnabled = isEnabled
        self.title = title
    }
    var body: some View {
        HStack(alignment: .center) {
            Toggle(isOn: $isEnabled) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 16))
                }
                .onReceive([isEnabled].publisher.first()) { (isEnabled) in
                    guard self.isEnabled != isEnabled else { return }
                    self.isEnabled = isEnabled
                }
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
        .background(Color.white)
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView(isEnabled: .constant(true), title: "Test")
            .previewDevice("iPhone 11 Pro Max")
    }
}
