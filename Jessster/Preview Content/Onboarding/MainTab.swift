//
//  MainTab.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI

struct MainTab: View {
    @Binding var isAuthenticated: Bool // Binding to isAuthenticated from ContentView

    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
        
        // Customize the appearance of the Tab Bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6 // Light gray background color
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        
        // Set the selected tab item's color to a dynamic color (black in light mode, white in dark mode)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .white : .black
            }
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
            TabView {
             
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                VideoTabView()
                    .tabItem {
                        Label("Video", systemImage: "video.fill")
                    }
                
                SectionsView()
                    .tabItem {
                        Label("Categories", systemImage: "square.grid.2x2")
                    }
                
                // Always show the Account tab, but switch between ProfileView and WelcomeView based on authentication status
                Group {
                    if isAuthenticated {
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.fill")
                            }
                    } else {
                        WelcomeView()
                            .tabItem {
                                Label("Account", systemImage: "person.fill")
                            }
                    }
                }
            }
        
        .onAppear {
            // Check authentication status when MainTab appears
            isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        }
 .environment(\.horizontalSizeClass, .compact) // Force compact layout on iPads
    }
}



struct MainTabView_Previews: PreviewProvider {
    @State static var isAuthenticated = true // You can change this value for testing

    static var previews: some View {
        MainTab(isAuthenticated: $isAuthenticated)
            .previewDevice("iPhone 12") // Change the device for preview if needed
            .previewLayout(.sizeThatFits)
    }
}

