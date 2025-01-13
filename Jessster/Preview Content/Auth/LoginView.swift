//
//  LoginView.swift
//  Jessster
//
//  Created by TEST on 13.01.2025.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Spacer()
            
            Text("This is a placeholder for the Login screen.")
                .font(.title2)
                .padding()
            
            Spacer()
            
            // Example of a "Login" button
            Button(action: {
                // Handle login action (to be implemented later)
            }) {
                Text("Login Button Placeholder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 40)
        }
        .navigationTitle("Login")
    }
}
