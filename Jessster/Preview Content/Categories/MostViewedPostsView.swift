//
//  MostViewedPostsView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//
import SwiftUI

struct MostViewedPostsView: View {
    @State private var posts: [Post] = []  // Array to hold posts
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    var language: String // The selected language for posts

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading most viewed posts...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Display posts as cards
                ScrollView {
                    LazyVStack(spacing: 16) {  // LazyVStack to stack items vertically
                        ForEach(posts) { post in
                            NavigationLink(
                                destination: PostDetailView(post: post),  // Pass the post directly (not as a binding)
                                label: {
                                    HStack(spacing: 16) {  // Use HStack to align title and image side by side
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(post.title)
                                                .font(.headline)
                                                .foregroundColor(.black)  // Change title color to black
                                                .lineLimit(4)  // Allow title to show up to 4 lines
                                                .truncationMode(.tail)  // Truncate the title with "..." if it exceeds 4 lines
                                            
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)  // Title and content on the left

                                        if !post.featuredImage.isEmpty { // Check if the image string is not empty
                                            let fullImageUrl = "https://res.cloudinary.com/dbm8xbouw/" + post.featuredImage
                                            AsyncImage(url: URL(string: fullImageUrl)) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView() // Placeholder while loading
                                                case .success(let image):
                                                    image.resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(8)
                                                case .failure:
                                                    Image(systemName: "photo") // Fallback image on failure
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
            }
        }
        .onAppear {
            fetchMostViewedPosts() // Fetch posts when the view appears
        }
        .navigationTitle("Most Viewed Posts") // Set the navigation title
    }

    private func fetchMostViewedPosts() {
        isLoading = true
        errorMessage = nil
        
        // Call your API function to fetch most viewed posts
        APIService.shared.fetchMostViewedPosts(language: language) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    errorMessage = "Failed to load posts: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct MostViewedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MostViewedPostsView(language: "en") // Replace with a test language
    }
}


