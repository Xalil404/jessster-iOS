//
//  PostDetailView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import SwiftUI
import WebKit

// WebView for rendering HTML content
struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct PostDetailView: View {
    var post: Post

    var body: some View {
        // Prepare HTML content for the entire post
        let cloudinaryBaseUrl = "https://res.cloudinary.com/dbm8xbouw/"
        let fullImageUrl = cloudinaryBaseUrl + post.featuredImage
        
        // Create the complete HTML content with title, image, excerpt, and content
        let htmlContent = """
        <html>
        <head>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 20px;
                }
                img {
                    max-width: 100%;
                    height: auto;
                    border-radius: 8px;
                    margin-bottom: 16px;
                }
                h1 {
                    font-size: 82px;
                    font-weight: bold;
                    margin-bottom: 16px;
                }
                .excerpt {
                    font-size: 38px;
                    color: gray;
                    margin-bottom: 16px;
                    padding-left: 25px; /* Add space on the left */
                    padding-right: 25px;
                }
                .content {
                    font-size: 46px;
                    margin-bottom: 16px;
                    line-height: 1.6;
                    padding-left: 25px; /* Add space on the left */
                    padding-right: 25px;
                }
                .views {
                    font-size: 36px;
                    color: #888;
                    text-align: center;
                }
            </style>
        </head>
        <body>
            <h1>\(post.title)</h1>
            <img src="\(fullImageUrl)" alt="Featured Image">
            <p class="excerpt">\("Excerpt: \(post.excerpt)")</p>
            <div class="content">\(post.content)</div>
            <p class="views">Views: \(post.numberOfViews)</p>
        </body>
        </html>
        """

       

                ZStack {
                    // WebView for HTML content
                    WebView(htmlContent: htmlContent)
                        .edgesIgnoringSafeArea(.all) // Optional: Makes the WebView use the entire screen
                    
                    // Share button overlay
                    VStack {
                        Spacer()
                        HStack {
                            // Like button on the left
                            Button(action: {
                                //  likePost()  // You can implement this function later
                            }) {
                                HStack {
                                    Image(systemName: "heart")
                                    Text("Like")
                                }
                                .padding(8)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.footnote)
                            }
                            .padding()
                            
                            
                            Spacer()
                            Button(action: {
                                sharePost()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share")
                                }
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.footnote)
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle(post.title)
            }

            // Share functionality
            func sharePost() {
                guard let url = URL(string: "https://jessster.com/posts/\(post.slug)") else { return }
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(activityVC, animated: true, completion: nil)
                }
            }
        }

        
        
        /*
        // Render HTML content in WebView
        WebView(htmlContent: htmlContent)
            .edgesIgnoringSafeArea(.all) // Optional: Makes the WebView use the entire screen
            .navigationTitle(post.title)
    }
}
*/





































/*
import SwiftUI
import WebKit

// WebView for rendering HTML content
struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

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
                let cloudinaryBaseUrl = "https://res.cloudinary.com/dbm8xbouw/"
                let fullImageUrl = cloudinaryBaseUrl + post.featuredImage

                if let imageUrl = URL(string: fullImageUrl) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(8)
                                .padding(.vertical)
                        case .failure:
                            Image(systemName: "photo")
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

                // Content - Render HTML using WebView
                WebView(htmlContent: post.content)
                    .frame(minHeight: 300) // Adjust height based on content

                // Number of Views
                Text("Views: \(post.numberOfViews)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationTitle(post.title)
    }
}
*/


/*
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
 */







