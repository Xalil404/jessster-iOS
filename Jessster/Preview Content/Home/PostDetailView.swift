//
//  PostDetailView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI

struct PostDetailView: View {
    var post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(post.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Feature Image (if available)
                // Base Cloudinary URL
                let cloudinaryBaseUrl = "https://res.cloudinary.com/dbm8xbouw/"

                // Construct the full image URL
                let fullImageUrl = cloudinaryBaseUrl + post.featuredImage

                if let imageUrl = URL(string: fullImageUrl) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Placeholder while loading
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(8)
                                .padding(.vertical)
                        case .failure:
                            Image(systemName: "photo") // Fallback image on failure
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(8)
                                .padding(.vertical)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Excerpt
                Text(post.excerpt)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                // Content - Strip HTML tags before displaying
                Text(stripHTML(from: post.content))
                    .font(.body)
                    .padding(.bottom)

                // Number of Views
                Text("Views: \(post.numberOfViews)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationTitle(post.title)  // Set the navigation bar title to the post title
    }

    // Function to strip HTML tags from the content
    func stripHTML(from text: String) -> String {
        let modifiedText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return modifiedText
    }
}







