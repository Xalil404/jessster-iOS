//
//  MainTab.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI

struct MainTab: View {
    
    init() {
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
            // Placeholder for BirthdayListView
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
            
            WelcomeView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
            .environment(\.colorScheme, .light) // Preview for light mode
        MainTab()
            .environment(\.colorScheme, .dark) // Preview for dark mode
    }
}


/*
import SwiftUI

struct MainTab: View {
    
    init() {
            // Customize the appearance of the Tab Bar
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemGray6 // Light gray background color
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    var body: some View {
            TabView {
                // Placeholder for BirthdayListView
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
                
                WelcomeView()
                    .tabItem {
                    Label("Profile", systemImage: "person.fill")
                    }
                
            }
        }
    }
   
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
*/
