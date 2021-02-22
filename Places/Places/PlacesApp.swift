//
//  PlacesApp.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/20/21.
//

import SwiftUI

@main
struct PlacesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(mapType: "Normal")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
