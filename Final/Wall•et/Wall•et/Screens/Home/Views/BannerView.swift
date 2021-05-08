//
//  BannerView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct BannerView: View {
    private let banner: Banner
    
    init(banner: Banner) {
        self.banner = banner
    }
    
    var body: some View {
        ZStack {
            Image(banner.image)
                .resizable()
                .cornerRadius(16)
                .frame(width: UIScreen.main.bounds.width / 2 - 16, height: 160)
                .padding(.vertical, 8)
        }.onTapGesture {
            guard let url = URL(string: banner.url) else { return }
            UIApplication.shared.open(url)
        }
        .cornerRadius(16)
        .shadow(color: Color(Assets.black.color).opacity(0.3) , radius: 8, x: 0, y: 0)
    }
}
