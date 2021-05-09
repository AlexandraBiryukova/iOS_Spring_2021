//
//  EmptyView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct EmptyView: View {
    enum IconType {
        case system(name: String)
        case icon(image: UIImage)
    }
    private let icon: IconType?
    private let title: String?
    private let description: String?
    private let actionTitle: String?
    private let action: () -> Void
    
    var iconView: Image {
        switch icon {
        case let .system(name):
            return Image(systemName: name)
        case let .icon(image):
            return Image(uiImage: image)
        default:
            return Image(.init())
        }
    }
    
    init(icon: IconType? = nil,
         title: String? = nil,
         description: String? = nil,
         actionTitle: String? = nil,
         action: @escaping () -> Void = {}) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if icon != nil {
                iconView
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color(Assets.gray2.color))
            }
            if let title = title {
                Text(title)
                    .foregroundColor(Color(Assets.gray2.color))
                    .font(.system(size: 20, weight: .semibold))
            }
            if let description = description {
                Text(description)
                    .foregroundColor(Color(Assets.gray2.color))
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            if let actionTitle = actionTitle {
                SecondaryButton(title: actionTitle, color: Assets.primary, image: nil) {
                    action()
                }
            }
        }
    }
}
