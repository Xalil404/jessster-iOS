//
//  ProfileView.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//

/* some profile features might not be fully complete like logout or delete profile */
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoggedOut = false
    @State private var user: User?
    @State private var isLoading = true
    @State private var errorMessage: String = ""
    @State private var isEditing = false // Track if the user is editing the profile
    
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Text("Loading user information...")
                        .font(.headline)
                        .padding()
                } else if let user = user {
                    Image("jessster") // Profile image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                    
                    Text("Username: \(user.username)")
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    
                    // Edit Profile Button
                    Button(action: {
                        isEditing.toggle() // Toggle the edit mode
                    }) {
                        Text("Edit Profile")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }
                    
                    // Logout Button
                    Button(action: {
                        logout()
                    }) {
                        Text("Log Out")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }

                    // Delete Account Button (Confirm before deletion)
                    Button(action: {
                        deleteAccount()
                    }) {
                        Text("Delete Account")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }
                } else {
                    Text("Failed to load user information")
                        .font(.subheadline)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isLoggedOut) {
                WelcomeView() // Your login view
            }
            .onAppear {
                fetchUserProfile()
            }
            .alert(isPresented: Binding<Bool>(
                get: { !errorMessage.isEmpty },
                set: { if !$0 { errorMessage = "" }}
            )) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isEditing) {
                EditProfileView(user: $user) // Show a sheet to edit profile
            }
        }
    }
    
    private func logout() {
        // Clear authToken and reset user data
        UserDefaults.standard.removeObject(forKey: "authToken")
        user = nil
        isLoggedOut = true
       
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

    // Delete Account function
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

                // After successful deletion, logout
                DispatchQueue.main.async {
                    logout()
                }
            }.resume()
        }
    }

struct EditProfileView: View {
    @Binding var user: User?
    @State private var username: String = ""
    
    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.headline)
                .padding()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save Changes") {
                saveChanges()
            }
            .padding()
        }
        .onAppear {
            if let user = user {
                self.username = user.username
            }
        }
    }
    
    private func saveChanges() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://jessster-476efeac7498.herokuapp.com/api/profile_update/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        let body = ["username": username]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                user?.username = username // Update the local user data
                // Maybe pop the edit view after saving
            }
        }.resume()
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
