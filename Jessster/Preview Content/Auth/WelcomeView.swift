//
//  WelcomeView.swift
//  Jessster
//
//  Created by TEST on 13.01.2025.
//

import SwiftUI

struct WelcomeView: View {
    // Detect the current color scheme (light or dark)
    @Environment(\.colorScheme) var colorScheme
    @State private var isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated") // Check authentication status
    
    var body: some View {
        
        NavigationView { // Wrap in NavigationView
            
            VStack(spacing: 10) {
                Spacer()
                
                // Logo Header
                HStack {
                    Spacer()
                    // Conditionally use different images for light and dark mode
                    Image(colorScheme == .dark ? "TheJesssterTimesLogo" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                        .padding(.trailing, 46)
                }
                
                Text("Enrich your Jessster experience by creating an account.")
                    .font(.system(size: 20)) // Adjust the font size to make it smaller
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Allow unlimited lines to prevent truncation
                    .padding(.horizontal, 20)
                    .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                Spacer()
                
                // Button Stack
                VStack(spacing: 20) {
                    // NavigationLink for Login
                    NavigationLink(destination: LoginView()) {
                        Text("L o g i n")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white) // Orange background
                            .foregroundColor(.black) // White text
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 2) // Black border with width 2
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    // NavigationLink for Sign Up
                    NavigationLink(destination: SignUpView()) {
                        Text("S i g n  U p")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 100) // Increase this value to push buttons up and prevent overlap with the navigation bar
            }
            .background(Color(red: 248/255, green: 247/255, blue: 245/255)) // Set background color
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("") // Set title to empty
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarTitleDisplayMode(.inline) // Ensure the title doesn't cause a back button
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap the preview in a NavigationView for proper simulation
            Group {
                WelcomeView()
                    .previewDisplayName("Light Mode")
                    .environment(\.colorScheme, .light)
                WelcomeView()
                    .previewDisplayName("Dark Mode")
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}

