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
                List(posts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) { // Reusing the existing PostDetailView
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.content)
                                .font(.subheadline)
                                .lineLimit(2) // Limit the content length to 2 lines
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
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

