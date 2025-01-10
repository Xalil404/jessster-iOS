//
//  JesssterApp.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI

@main
struct JesssterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
