//
//  SignUpView.swift
//  Jessster
//
//  Created by TEST on 13.01.2025.
//


import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack {
            Text("Sign Up Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Spacer()
            
            Text("This is a placeholder for the Sign Up screen.")
                .font(.title2)
                .padding()
            
            Spacer()
            
            // Example of a "Sign Up" button
            Button(action: {
                // Handle sign up action (to be implemented later)
            }) {
                Text("Sign Up Button Placeholder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 40)
        }
        .navigationTitle("Sign Up")
    }
}
