//
//  ProgressBar.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/15/21.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width ,
                           height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(Assets.grayLight.color))
                    .cornerRadius(45.0)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .gradientForeground(colors: [Color(Assets.secondary.color), Color(Assets.primary.color)])
                    .animation(.easeIn(duration: 0.5))
                    .cornerRadius(45.0)
            }.cornerRadius(45.0)
        }
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
