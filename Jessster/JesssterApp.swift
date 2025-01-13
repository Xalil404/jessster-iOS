//
//  JesssterApp.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import GoogleSignIn
import SwiftUI

@main
struct JesssterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                                                                   GIDSignIn.sharedInstance.handle(url)  // Handle the URL for Google Sign-In
                                                               }
        }
    }
}

