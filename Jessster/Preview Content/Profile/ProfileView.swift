//
//  ProfileView.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoggedOut = false
    @State private var user: User?
    @State private var isLoading = true
    @State private var errorMessage: String = ""
    @State private var isEditing = false

    var body: some View {
        VStack {
            // Logo Header
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50) // Adjust the height of the logo
                    .padding(.leading, 46) // Custom padding

                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape") // Settings icon
                        .padding()
                        .font(.system(size: 24))
                        .foregroundColor(colorScheme == .dark ? .white : .black) // Icon color changes based on mode
                }

                Spacer()
            }
            .padding(.top, 1) // Add some padding on top for spacing

            if isLoading {
                Text("Loading user information...")
                    .font(.headline)
                    .padding()
            } else if let user = user {
                Image("jessster") // Profile image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .padding(.bottom, 10)

                Text("Username: \(user.username)")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                NavigationLink(destination: BookmarksView()) {
                    Text("Saved Posts")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
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
        .navigationBarBackButtonHidden(true) // Hide the back button
        .navigationBarItems(leading: EmptyView()) // Ensure no back button is shown
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


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
