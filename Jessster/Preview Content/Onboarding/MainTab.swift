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
                
                
                // Placeholder for Categories
                Text("Feature Three for categories")
                    .tabItem {
                        Label("Categories", systemImage: "square.grid.2x2")
                    }

                // Placeholder for Profile
                Text("Feature four for profile")
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
