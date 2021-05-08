//
//  MainTabView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label( title: { Text(L10n.tabHome) },
                           icon: { Image(Assets.tabHome.name) })
                }
            
            ContentView()
                .tabItem {
                    Label( title: { Text(L10n.tabPlaces) },
                           icon: { Image(Assets.tabList.name) })
                }
            ContentView()
                .tabItem {
                    Label( title: { Text(L10n.tabProfile) },
                           icon: { Image(Assets.tabProfile.name) })
                }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
