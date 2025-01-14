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
                        // likePost()  // You can implement this function later
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


                    // Comments button in the middle
                    NavigationLink(destination: CommentsView(postSlug: post.slug)) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Comments")
                        }
                        .padding(8)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.footnote)
                    }
                    .padding(.horizontal, 30)

                    Spacer()
                    // Share button on the right
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



























