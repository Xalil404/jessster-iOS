//
//  BookmarksView.swift
//  Jessster
//
//  Created by TEST on 16.01.2025.
//
import SwiftUI

struct BookmarksView: View {
    @State private var likedPosts: [Post] = [] // Array to hold liked posts
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme
    
    // Function to fetch liked posts (this would interact with the API)
    private func fetchLikedPosts() {
        isLoading = true
        errorMessage = nil  // Reset error message
        
        // Call the API function to fetch liked posts
        APIService.shared.fetchLikedPosts { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let posts):
                    likedPosts = posts
                case .failure(let error):
                    errorMessage = "Error fetching liked posts: \(error.localizedDescription)"
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Image Header
                HStack {
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .padding(.horizontal)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // Show loading indicator while fetching liked posts
                if isLoading {
                    ProgressView("Loading liked posts...")
                        .padding()
                }
                
                // Display error message if there's an error
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                // Results Section for liked posts
                if !likedPosts.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(likedPosts) { post in
                                NavigationLink(
                                    destination: PostDetailView(post: post), // Assuming a PostDetailView for individual posts
                                    label: {
                                        HStack(spacing: 16) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(post.title)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .lineLimit(4)
                                                    .truncationMode(.tail)
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            if !post.featuredImage.isEmpty {
                                                let fullImageUrl = "https://res.cloudinary.com/dbm8xbouw/" + post.featuredImage
                                                AsyncImage(url: URL(string: fullImageUrl)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable()
                                                            .scaledToFill()
                                                            .frame(width: 100, height: 100)
                                                            .cornerRadius(8)
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 100, height: 100)
                                                            .cornerRadius(8)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                } else if !isLoading {
                    // Show a message when no liked posts are found
                    Text("No liked posts found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                
                Spacer()
            }
            .onAppear {
                fetchLikedPosts() // Fetch liked posts when the view appears
            }
        }
    }
}


struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a preview with mock data for liked posts
        BookmarksView()
            .previewLayout(.sizeThatFits) // This makes the preview size flexible
            .padding()
    }
}

