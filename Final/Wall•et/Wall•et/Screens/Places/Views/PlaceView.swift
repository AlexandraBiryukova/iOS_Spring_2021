//
//  PlaceView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct PlaceView: View {
    private let place: TransactionPlace
    
    init(place: TransactionPlace) {
        self.place = place
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 8) {
                ZStack {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .foregroundColor(Color(Assets.secondary.color))
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .frame(width: 64, height: 64)
                .background(Color(Assets.background.color))
                .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    if let name = place.name {
                        Text(name)
                            .foregroundColor(Color(Assets.black.color))
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text([place.description, place.address, place.category.title].first(where: { !$0.isEmpty }) ?? "")
                        .foregroundColor(Color(Assets.gray2.color))
                        .font(.system(size: 14, weight: .regular))
                }
                Spacer()
                if place.transactions > 0 {
                    ZStack {
                        Text(String(place.transactions))
                            .foregroundColor(Color(Assets.white.color))
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .frame(width: 32, height: 32)
                    .background(Color(Assets.secondary.color))
                    .clipShape(Circle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(Assets.white.color))
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(Assets.divider.color), lineWidth: 1)
        )
        
    }
}
