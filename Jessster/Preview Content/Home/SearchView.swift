//
//  SearchView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//
import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""  // Search text entered by the user
    @State private var searchResults: [SearchResult] = []  // Search results returned from the API
    @State private var isLoading: Bool = false  // Loading state while searching
    @State private var errorMessage: String? = nil  // Error message, if any
    
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
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Cancel Button
                    Button(action: {
                        // Go back to the previous view
                        // This will dismiss the current view
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    
                    // Search Input Field
                    TextField("Search for something...", text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText, perform: { _ in
                            performSearch()  // Trigger search whenever text changes
                        })
                        .padding(.horizontal)
                    
                    Spacer()  // Push cancel and search field to the left
                }
                
                // Text under the search input field
                Text("Enter a search term to find results.")
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
                    List(searchResults, id: \.id) { result in
                        Text(result.title)  // Assuming 'SearchResult' has a 'title' field
                    }
                    .padding(.top)
                } else if !isLoading {
                    // Show a message when no results are found
                    Text("No results found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                
                Spacer()
            }
            .navigationTitle("Search") // Set a navigation title
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
