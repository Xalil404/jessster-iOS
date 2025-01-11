//
//  CategoriesView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//

import SwiftUI

struct SectionsView: View {
    @State private var selectedLanguage: String = "en" // Default language
    @State private var languages = ["en", "ru", "ar", "es"] // Example languages, based on your picker
    var body: some View {
        NavigationView { // Wrap the content in a NavigationView
            VStack {
                // Language Picker
                LanguagePickerView(selectedLanguage: $selectedLanguage)
                    .padding()

                // Most Viewed Posts Section
                NavigationLink(destination: MostViewedPostsView(language: selectedLanguage)) {
                    Text("Most Viewed Posts")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top)
                
                // Most Liked Posts Section
                NavigationLink(destination: MostLikedPostsView(language: selectedLanguage)) {
                    Text("Most Liked Posts")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top)
                
                // Most Commented Posts Section
                NavigationLink(destination: MostCommentedPostsView(language: selectedLanguage)) {
                    Text("Most Commented Posts")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        SectionsView()
    }
}


