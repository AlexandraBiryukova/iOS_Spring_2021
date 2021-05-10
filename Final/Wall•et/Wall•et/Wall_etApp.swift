//
//  Wall_etApp.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

@main
struct Wall_etApp: App {
    init() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundImage = .init()
        UITabBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().shadowImage = .init()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
