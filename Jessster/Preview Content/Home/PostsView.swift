//
//  PostsView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//

import SwiftUI

struct PostsView: View {
    @Binding var posts: [Post]  // Binding to the parent view's posts
    @Binding var isLoading: Bool  // Binding to the parent view's loading state
    @Binding var errorMessage: String?  // Binding to the parent view's error message
    @Binding var selectedLanguage: String  // Binding to the parent view's selected language
    @Binding var selectedCategory: Category?  // Binding to the parent view's selected category

    var body: some View {
        // Loading state for posts
        if isLoading {
            ProgressView("Loading Posts...")
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
                                            .truncationMode(.tail)  // Truncate the title with "..." if it exceeds 2 lines
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)  // Title on the left, taking all available space

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
}
 

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        // Ensure to use .constant to pass a Binding to the preview
        PostsView(posts: .constant([]), isLoading: .constant(false), errorMessage: .constant(nil), selectedLanguage: .constant("en"), selectedCategory: .constant(nil))
    }
}

