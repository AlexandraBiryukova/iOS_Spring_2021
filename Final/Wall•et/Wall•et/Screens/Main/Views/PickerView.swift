//
//  PickerView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

protocol PickerItem: Codable {
    var title: String { get }
}

struct Placeholder: PickerItem {
    var title: String { "" }
}

struct PickerView<Item: PickerItem>: View {
    @Binding var selectedItem: Item
    @State var presentActionSheet = false
    let icon: String?
    let title: String
    let items: [Item]
    let completion: () -> Void
    
    init(selectedItem: Binding<Item>, items: [Item], title: String, icon: String? = nil, completion: @escaping () -> Void = {}) {
    _selectedItem = selectedItem
        self.items = items
        self.title = title
        self.icon = icon
        self.completion = completion
    }
    
    var buttons: [ActionSheet.Button] {
        var actions: [ActionSheet.Button] = items.map { item in
            .default(Text(item.title), action: {
                selectedItem = item
                completion()
            })
        }
        actions.append(.cancel {
            presentActionSheet = false
        })
        return actions
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .gradientForeground(colors: [Color(Assets.primary.color), Color(Assets.secondary.color)])
            }
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Color(Assets.black.color))
            Spacer()
            Text(selectedItem.title)
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
            guard !items.isEmpty else {
                completion()
                return
            }
            presentActionSheet = true
        }
        .actionSheet(isPresented: $presentActionSheet, content: {
            ActionSheet(title: Text(title), message: nil, buttons: buttons)
        })
    }
}
