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
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode
    @State private var showSearch = false // To track the search screen navigation
    
    var body: some View {
        NavigationView { // Wrap the content in a NavigationView
            VStack {
                // Logo Header
                HStack {
                    Spacer()
                    // Conditionally use different images for light and dark mode
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
        
    
                    // Search Icon Button
                    NavigationLink(destination: SearchView(), isActive: $showSearch) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .foregroundColor(colorScheme == .dark ? .white : .black) // Icon color changes based on mode
                    }
                    
                    Spacer()
                }
                .padding(.top, 1) // Add some padding on top for spacing

                // Language Picker
                LanguagePickerView(selectedLanguage: $selectedLanguage)

                // Most Viewed Posts Section (Card Style)
                SectionCardView(title: "Most Viewed Posts", imageName: "jessster", destination: MostViewedPostsView(language: selectedLanguage))
                    .padding(.top)

                // Most Liked Posts Section (Card Style)
                SectionCardView(title: "Most Liked Posts", imageName: "logo", destination: MostLikedPostsView(language: selectedLanguage))
                    .padding(.top)

                // Most Commented Posts Section (Card Style)
                SectionCardView(title: "Most Commented Posts", imageName: "jessster", destination: MostCommentedPostsView(language: selectedLanguage))
                    .padding(.top)
                
                Spacer()
            }
       
        }
    }
}

struct SectionCardView<Destination: View>: View {
    var title: String
    var imageName: String
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .foregroundColor(.black)
                    .bold() // Make the title bold

                // Image corresponding to the section
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100) // Adjust the size of the image
                    .padding(.trailing)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10) // Rounded corners for the card
                .fill(Color.white)
                .shadow(radius: 5)) // Add shadow to create a card effect
        }
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        SectionsView()
    }
}


/*
import SwiftUI

struct SectionsView: View {
    @State private var selectedLanguage: String = "en" // Default language
    @State private var languages = ["en", "ru", "ar", "es"] // Example languages, based on your picker
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode
    
    var body: some View {
        NavigationView { // Wrap the content in a NavigationView
            VStack {
                // Logo Header
                            HStack {
                                Spacer()
                                // Conditionally use different images for light and dark mode
                                Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50) // Adjust the height of the logo
                                    .padding(.leading,1) // Custom padding
                                Spacer()
                            }
                            .padding(.top, 1) // Add some padding on top for spacing
                // Language Picker
                LanguagePickerView(selectedLanguage: $selectedLanguage)

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
*/

