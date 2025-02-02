//
//  ContentView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

/*
import SwiftUI
import CoreData
import FirebaseAnalytics

struct ContentView: View {
    @State private var showSplashScreen = true
    @State private var isAuthenticated = false // Tracks user authentication
    @State private var hasSeenOnboardingView = UserDefaults.standard.bool(forKey: "hasSeenOnboardingView") // Tracks onboarding completion
    
    var body: some View {
        if showSplashScreen {
            SplashScreen()
                .onAppear {
                    // Simulate splash screen delay and check app state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            // Always check the authentication and onboarding state on app launch
                            isAuthenticated = checkAuthenticationStatus()
                            showSplashScreen = false
                            
                            // Log splash screen completion event
                            Analytics.logEvent("splash_screen_completed", parameters: [
                                "timestamp": Date().timeIntervalSince1970
                            ])
                        }
                    }
                }
        } else {
            // Determine which view to show based on state
            if !hasSeenOnboardingView {
                OnboardingView(isAuthenticated: $isAuthenticated)
                    .onDisappear {
                        // Mark onboarding as completed
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboardingView")
                        hasSeenOnboardingView = true
                        
                        // Log onboarding completion event
                        Analytics.logEvent("onboarding_completed", parameters: [
                            "user_id": "example_user_id",
                            "timestamp": Date().timeIntervalSince1970
                        ])
                    }
            } else if !isAuthenticated {
                MainTab(isAuthenticated: $isAuthenticated)
                    .onAppear {
                        // Log event for unauthenticated user accessing the main tab
                        Analytics.logEvent("main_tab_accessed", parameters: [
                            "authenticated": false
                        ])
                    }
            } else {
                MainTab(isAuthenticated: $isAuthenticated)
                    .onAppear {
                        // Log event for authenticated user accessing the main tab
                        Analytics.logEvent("main_tab_accessed", parameters: [
                            "authenticated": true
                        ])
                    }
            }
        }
    }

    /// Function to check if the user is authenticated
    private func checkAuthenticationStatus() -> Bool {
        // Replace this logic with your actual authentication check
        return UserDefaults.standard.bool(forKey: "isAuthenticated")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 */


import SwiftUI
import CoreData
import FirebaseAnalytics

struct ContentView: View {
    @State private var showSplashScreen = true
    @State private var isAuthenticated = false // Tracks user authentication
    @State private var hasSeenOnboardingView = UserDefaults.standard.bool(forKey: "hasSeenOnboardingView") // Tracks onboarding completion
    
    var body: some View {
        if showSplashScreen {
            SplashScreen()
                .onAppear {
                    // Simulate splash screen delay and check app state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            // Always check the authentication and onboarding state on app launch
                            isAuthenticated = checkAuthenticationStatus()
                            showSplashScreen = false
                        }
                    }
                }
        } else {
            // Determine which view to show based on state
            if !hasSeenOnboardingView {
                OnboardingView(isAuthenticated: $isAuthenticated)
                    .onDisappear {
                        // Mark onboarding as completed
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboardingView")
                        hasSeenOnboardingView = true
                    }
            } else if !isAuthenticated {
                MainTab(isAuthenticated: $isAuthenticated) // Show main tab screen if not authenticated
            } else {
                MainTab(isAuthenticated: $isAuthenticated) // Show main tab view for authenticated users
            }
        }
    }


    /// Function to check if the user is authenticated
    private func checkAuthenticationStatus() -> Bool {
        // Replace this logic with your actual authentication check
        return UserDefaults.standard.bool(forKey: "isAuthenticated")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


