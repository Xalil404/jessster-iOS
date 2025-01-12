//
//  HomeView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI

struct HomeView: View {
    @State private var showSearch = false // To track the search screen navigation
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom header
                HStack {
                    Spacer()
                    // Conditionally use different images for light and dark mode
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                   
                    Spacer()
                    
                    NavigationLink(destination: SearchView(), isActive: $showSearch) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .foregroundColor(colorScheme == .dark ? .white : .black) // Icon color changes based on mode
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

