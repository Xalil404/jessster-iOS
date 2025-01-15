//
//  JesssterApp.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import GoogleSignIn
import SwiftUI
import FirebaseCore

// AppDelegate class for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct JesssterApp: App {
    let persistenceController = PersistenceController.shared

    // Register AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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

/*
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
*/
