//
//  SettingsView.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedURL: URL? // URL to open in the web view
    @State private var showWebView = false // Controls whether the web view is shown
    @State private var isLoggedOut = false
    @State private var user: User? // User data
    @State private var isLoading = true // To handle loading state
    @State private var errorMessage: String = "" // To handle errors

    // For navigation control
    @State private var navigateToWelcomeView = false

    // Confirmation alert state for account deletion
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Settings")) {
                        Button("About") {
                            print("About button tapped")
                            if let url = URL(string: "https://www.jessster.com/about") {
                                selectedURL = url
                            }
                            showWebView = true
                        }
                        /*
                        Button("Donate") {
                            print("Donate button tapped")
                            if let url = URL(string: "https://www.jessster.com/donate") {
                                selectedURL = url
                            }
                            showWebView = true
                        }
                         */
                        Button("Contact") {
                            print("Contact button tapped")
                            if let url = URL(string: "https://www.jessster.com/contact") {
                                selectedURL = url
                            }
                            showWebView = true
                        }
                    }
                    Section (header: Text("Danger Zone")) {
                        Button(action: {
                            logout()
                        }) {
                            Text("Log Out")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showDeleteAccountAlert = true
                        }) {
                            Text("Delete Account")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                }
              
                        // Navigation to WelcomeView
                        NavigationLink(destination: WelcomeView(), isActive: $navigateToWelcomeView) {
                            EmptyView()
                        }
                    }
                    .navigationTitle("Settings")
                    .sheet(isPresented: $showWebView) {
                        if let url = selectedURL {
                            SafariViewControllerWrapper(url: url)
                        } else {
                            Text("URL not available")
                        }
                    }
                    .onAppear {
                        fetchUserProfile() // Ensure user data is fetched on view load
                    }
                    // Delete account confirmation alert
                    .alert(isPresented: $showDeleteAccountAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("This action is permanent. Do you want to delete your account?"),
                            primaryButton: .destructive(Text("Delete Account")) {
                                deleteAccount()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            
    
    private func logout() {
        // Clear authToken and reset user data
        UserDefaults.standard.removeObject(forKey: "authToken")
        user = nil
        navigateToWelcomeView = true
    }

    func deleteAccount() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://jessster-476efeac7498.herokuapp.com/api/profile/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                logout()
            }
        }.resume()
    }

    private func fetchUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://jessster-476efeac7498.herokuapp.com/api/profile/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
                return
            }

            guard let data = data else { return }

            do {
                let fetchedUser = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.user = fetchedUser
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode user data."
                    isLoading = false
                }
            }
        }.resume()
    }
}

struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Nothing to update
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


