//
//  Onboarding.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    @State private var showMainTab = false // State variable for navigation
    @Binding var isAuthenticated: Bool // Pass this binding to track authentication
    
    // Detect the current color scheme (light or dark)
    @Environment(\.colorScheme) var colorScheme
    
    private let onboardingData = [
        OnboardingData(imageName: "Onboarding1", title: "On boarding feature 1", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "Onboarding2", title: "On boarding feature 2", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "Onboarding3", title: "On boarding feature 3", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan.")
    ]

    var body: some View {
        NavigationStack { // Use NavigationStack instead of NavigationView
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPage(data: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Progress indicators
                
                Button(action: {
                    if currentIndex < onboardingData.count - 1 {
                        withAnimation {
                            currentIndex += 1
                        }
                    } else {
                        // Navigate to the welcome screen
                        isAuthenticated = true // Mark user as authenticated after completing onboarding
                        showMainTab = true
                    }
                }) {
                    Text(currentIndex < onboardingData.count - 1 ? "N e x t" : "G e t  S t a r t e d")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 0, blue: 0))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .padding(.top, 60)
                }
            }
            .padding(.bottom, 50)
            .background(Color(red: 248/255, green: 247/255, blue: 245/255)) // Set background color
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $showMainTab) { // Navigate to Maintab
                MainTab(isAuthenticated: $isAuthenticated) // Pass the binding to MainTab
            }
        }
    }
}

struct OnboardingPage: View {
    let data: OnboardingData
    
    // Detect the current color scheme (light or dark)
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Image(data.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
            
            Text(data.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
            
            Text(data.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
        }
    }
}

struct OnboardingData {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView(isAuthenticated: .constant(false)) // Pass a constant binding for preview
                .previewDisplayName("Light Mode")
                .environment(\.colorScheme, .light)
            OnboardingView(isAuthenticated: .constant(false)) // Pass a constant binding for preview
                .previewDisplayName("Dark Mode")
                .environment(\.colorScheme, .dark)
        }
    }
}

/*
import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    @State private var showMainTab = false // State variable for navigation
    
    // Detect the current color scheme (light or dark)
    @Environment(\.colorScheme) var colorScheme
    
    private let onboardingData = [
        OnboardingData(imageName: "Onboarding1", title: "On boarding feature 1", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "Onboarding2", title: "On boarding feature 2", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan."),
        OnboardingData(imageName: "Onboarding3", title: "On boarding feature 3", description: "Sed accumsan sit amet magna fringilla accumsan. Sed accumsan sit amet magna fringilla accumsan.")
    ]

    var body: some View {
        NavigationStack { // Use NavigationStack instead of NavigationView
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPage(data: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Progress indicators
                
                Button(action: {
                    if currentIndex < onboardingData.count - 1 {
                        withAnimation {
                            currentIndex += 1
                        }
                    } else {
                        // Navigate to the welcome screen
                        showMainTab = true
                    }
                }) {
                    Text(currentIndex < onboardingData.count - 1 ? "N e x t" : "G e t  S t a r t e d")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 0, blue: 0))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .padding(.top, 60)
                }
            }
            .padding(.bottom, 50)
            .background(Color(red: 248/255, green: 247/255, blue: 245/255)) // Set background color
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $showMainTab) { // Navigate to Maintab
                MainTab()
            }
        }
    }
}


struct OnboardingPage: View {
    let data: OnboardingData
    
    // Detect the current color scheme (light or dark)
        @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Image(data.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
            
            Text(data.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
            
            Text(data.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(colorScheme == .dark ? .black : .black) // Dynamic text color
        }
    }
}

struct OnboardingData {
    let imageName: String
    let title: String
    let description: String
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
                .previewDisplayName("Light Mode")
                .environment(\.colorScheme, .light)
            OnboardingView()
                .previewDisplayName("Dark Mode")
                .environment(\.colorScheme, .dark)
        }
    }
}
*/
