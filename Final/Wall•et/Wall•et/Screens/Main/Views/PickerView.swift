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

struct PickerView<Item: PickerItem>: View {
    @Binding var selectedItem: Item
    @State var presentActionSheet = false
    let title: String
    let items: [Item]
    
    init(selectedItem: Binding<Item>, items: [Item], title: String) {
    _selectedItem = selectedItem
        self.items = items
        self.title = title
    }
    
    var buttons: [ActionSheet.Button] {
        var actions: [ActionSheet.Button] = items.map { item in
            .default(Text(item.title), action: { selectedItem = item })
        }
        actions.append(.cancel {
            presentActionSheet = false
        })
        return actions
    }
    
    var body: some View {
        HStack(spacing: 4) {
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
            presentActionSheet = true
        }
        .actionSheet(isPresented: $presentActionSheet, content: {
            ActionSheet(title: Text(title), message: nil, buttons: buttons)
        })
    }
}
