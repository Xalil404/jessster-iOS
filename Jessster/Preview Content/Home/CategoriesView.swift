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
    @State private var selectedCategory: Category? = nil

    var body: some View {
        NavigationView {  // Wrap with NavigationView to enable navigation
            VStack {
                LanguagePickerView(selectedLanguage: $selectedLanguage)

                CategoryListView(categories: $categories, selectedCategory: $selectedCategory)

                PostsView(posts: $posts, isLoading: $isLoading, errorMessage: $errorMessage, selectedLanguage: $selectedLanguage, selectedCategory: $selectedCategory)
                
                Spacer() // Push content to the top
            }
            .onAppear {
                fetchCategories()
                fetchPosts()  // Fetch posts when the view appears (for selected language)
            }
            .onChange(of: selectedLanguage) { _ in
                fetchCategories()  // Fetch categories whenever the language changes
                fetchPosts()  // Fetch posts for the new language
            }
            .onChange(of: selectedCategory) { _ in
                if let category = selectedCategory {
                    fetchPostsByCategory(category: category)  // Fetch posts by category
                } else {
                    fetchPosts()  // Fetch all posts for the selected language if no category is selected
                }
            }
        }
    }

    // Fetch categories function
    private func fetchCategories() {
        APIService.shared.fetchCategories(language: selectedLanguage) { result in
            switch result {
            case .success(let fetchedCategories):
                DispatchQueue.main.async {
                    self.categories = fetchedCategories
                    // Automatically select the first category if none is selected
                    if self.selectedCategory == nil, let firstCategory = fetchedCategories.first {
                        self.selectedCategory = firstCategory
                    }
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }

    // Fetch posts function - Fetch all posts when no category is selected
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

    // Fetch posts by category function
    private func fetchPostsByCategory(category: Category) {
        isLoading = true  // Show loading indicator while fetching posts
        APIService.shared.fetchPostsByCategory(categorySlug: category.slug, language: selectedLanguage) { result in
            DispatchQueue.main.async {
                isLoading = false  // Hide loading indicator after fetching
                switch result {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    errorMessage = "Failed to load posts for category \(category.name): \(error.localizedDescription)"
                }
            }
        }
    }
}





struct CategoryListView: View {
    @Binding var categories: [Category]
    @Binding var selectedCategory: Category?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories) { category in
                    CategoryButtonView(category: category, selectedCategory: $selectedCategory)
                }
            }
        }
        .padding()
    }
}

struct CategoryButtonView: View {
    var category: Category
    @Binding var selectedCategory: Category?

    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category.name)
                .padding()
                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2)) // Change color when selected
                .foregroundColor(selectedCategory == category ? .white : .black) // Change text color when selected
                .cornerRadius(10)
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
