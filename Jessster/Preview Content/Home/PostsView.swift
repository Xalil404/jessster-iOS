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
            // Display posts based on selected language
            List(posts) { post in
                NavigationLink(
                    destination: PostDetailView(post: post),  // Navigate to PostDetailView
                    label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.excerpt)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                Text("By \(post.author)")
                                    .font(.caption)
                                Spacer()
                                Text(post.createdOn)
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                )
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(posts: .constant([]), isLoading: .constant(false), errorMessage: .constant(nil), selectedLanguage: .constant("en"), selectedCategory: .constant(nil))
    }
}

