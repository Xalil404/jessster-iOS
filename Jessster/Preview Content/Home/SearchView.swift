//
//  SearchView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//
import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""       // Search text entered by the user
    @State private var searchResults: [SearchResult] = [] // Search results returned from the API
    @State private var isLoading: Bool = false      // Loading state while searching
    @State private var errorMessage: String? = nil  // Error message, if any
    
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme
    
    // Function to perform the actual search
    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []  // Clear results if the search text is empty
            return
        }
        
        isLoading = true  // Start loading
        errorMessage = nil  // Reset any previous error message
        
        // Call the API function to fetch search results
        APIService.shared.fetchSearchResults(query: searchText) { result in
            DispatchQueue.main.async {
                isLoading = false  // Stop loading
                switch result {
                case .success(let results):
                    searchResults = results  // Update search results
                case .failure(let error):
                    errorMessage = "Error fetching results: \(error.localizedDescription)"  // Set error message
                }
            }
        }
    }
    
    // Function to convert SearchResult to Post
    private func convertToPost(_ searchResult: SearchResult) -> Post {
        return Post(
            id: searchResult.id,
            title: searchResult.title,
            slug: searchResult.slug,
            author: searchResult.author,
            featuredImage: searchResult.featuredImage,
            excerpt: searchResult.excerpt,
            content: searchResult.content,
            status: searchResult.status,
            category: searchResult.category,
            language: searchResult.language,
            numberOfViews: searchResult.numberOfViews,
            likesCount: searchResult.likesCount,
            commentCount: searchResult.commentCount,
            createdOn: searchResult.createdOn,
            updatedOn: searchResult.updatedOn
        )
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Image Header
                HStack {
                    // Conditionally use different images for light and dark mode
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit() // Ensure the image scales to fit its container
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.horizontal) // Add horizontal padding to ensure it doesn't touch the edges
                    Spacer() // Push the image to the left
                }
                .frame(maxWidth: .infinity) // Make the HStack span the entire width of the screen
                .padding(.top) // Add top padding to separate it from the rest of the content
                
                // Search Input Field
                HStack {
                    TextField("Search for something...", text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onSubmit { // Trigger search on Enter/Return key press
                            performSearch()
                        }
                    
                    Spacer()  // Push cancel and search field to the left
                }
                
                // Text under the search input field
                Text("Enter a search term and press Submit to find results.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                // Show loading indicator while searching
                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                }
                
                // Display error message if there's an error
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                // Results Section
                if !searchResults.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 16) {  // LazyVStack to stack items vertically
                            ForEach(searchResults) { result in
                                NavigationLink(
                                    destination: PostDetailView(post: convertToPost(result)),  // Pass the converted result to PostDetailView
                                    label: {
                                        HStack(spacing: 16) {  // Use HStack to align title and image side by side
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(result.title)
                                                    .font(.headline)
                                                    .foregroundColor(.black)  // Change title color to black
                                                    .lineLimit(4)  // Allow title to show up to 4 lines
                                                    .truncationMode(.tail)  // Truncate the title with "..." if it exceeds 4 lines
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)  // Title on the left, taking all available space
                                            
                                        
                                            // Check if there's a featured image
                                            if !result.featuredImage.isEmpty {
                                                let fullImageUrl = "https://res.cloudinary.com/dbm8xbouw/" + result.featuredImage
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
                } else if !isLoading {
                    // Show a message when no results are found
                    Text("No results found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                
                Spacer()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
