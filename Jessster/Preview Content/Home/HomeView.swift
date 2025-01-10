//
//  HomeView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Any header or other UI elements for the Home screen can go here

                // Insert the CategoriesView component here
                CategoriesView()
                    .padding()
                    .background(Color.white) // You can adjust the background as needed
                    .cornerRadius(10) // Optional: Add corner radius for styling
                
                // Divider to separate categories from posts
                Divider()
                    .padding(.horizontal)

                Spacer() // Push content to the top
            }
            .navigationTitle("Home") // Set a navigation title for the Home screen
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

