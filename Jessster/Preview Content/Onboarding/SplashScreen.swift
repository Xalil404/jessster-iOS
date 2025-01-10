//
//  SplashScreen.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI

struct SplashScreen: View {
    // Detect the current color scheme (light or dark)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            // Main splash image at the top
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)

            // Image of Jessster right below the logo
            Image("jessster")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.top, -70)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the VStack fills the available space
        .background(Color(red: 248/255, green: 247/255, blue: 245/255))
        .edgesIgnoringSafeArea(.all) // Extend the background to the edges of the screen
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Navigate to the first onboarding screen
            }
        }
    }
}



struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreen()
                .previewDisplayName("Light Mode")
                .environment(\.colorScheme, .light)
            SplashScreen()
                .previewDisplayName("Dark Mode")
                .environment(\.colorScheme, .dark)
        }
    }
}
