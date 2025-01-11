//
//  HomeView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI

struct HomeView: View {
    @State private var showSearch = false // To track the search screen navigation
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom header
                HStack {
                    Spacer()
                    Text("The Jessster Times")
                        .font(.custom("Engravers' Old English BT", size: 24)) // Adjust to New York Times-like font
                        .fontWeight(.bold) // Optional: Make the text bold
                        .foregroundColor(.black)
                        .padding(.leading, 46) // Add custom padding to push text slightly to the right
                        .frame(maxWidth: .infinity) // Make text take all available space
                        .multilineTextAlignment(.center) // Center the text within the frame
                    Spacer()
                    
                    NavigationLink(destination: SearchView(), isActive: $showSearch) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .foregroundColor(.black)
                    }
                }

                // Insert the CategoriesView component here
                CategoriesView()
                    .background(Color.white) // Adjust the background as needed
                
                Spacer() // Push content to the top
            }
            .navigationBarHidden(true) // Hides the default navigation title
        }
    }
}




/*
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Any header or other UI elements for the Home screen can go here

                // Insert the CategoriesView component here
                CategoriesView()
                    .background(Color.white) // You can adjust the background as needed
    
                Spacer() // Push content to the top
            }
            .navigationTitle("Home") // Set a navigation title for the Home screen
        }
    }
}
*/
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

