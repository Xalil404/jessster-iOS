//
//  Home.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI

struct CategoriesView: View {
    @State private var categories: [Category] = []
    @State private var posts: [Post] = []  // Array to hold posts
    @State private var selectedLanguage = "en" // Default language is English
    @State private var isLoading = false  // Loading state for posts
    @State private var errorMessage: String?  // Error message for posts

    var body: some View {
        NavigationView {  // Wrap with NavigationView to enable navigation
            VStack {
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Russian").tag("ru")
                    Text("Arabic").tag("ar")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Display categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories) { category in
                            Text(category.name)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()

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
            .onAppear {
                fetchCategories()
                fetchPosts()  // Fetch posts when the view appears
            }
            .onChange(of: selectedLanguage) { _ in
                fetchCategories()
                fetchPosts()  // Fetch posts whenever the language changes
            }
        }
    }

    private func fetchCategories() {
        APIService.shared.fetchCategories(language: selectedLanguage) { result in
            switch result {
            case .success(let fetchedCategories):
                DispatchQueue.main.async {
                    self.categories = fetchedCategories
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }

    private func fetchPosts() {
        isLoading = true  // Show loading indicator while fetching posts
        APIService.shared.fetchPosts(language: selectedLanguage) { result in
            DispatchQueue.main.async {
                isLoading = false  // Hide loading indicator after fetching
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

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}



