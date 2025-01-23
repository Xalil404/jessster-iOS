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
    @State private var isLiked: Bool = false
    @State private var errorMessage: String?
    @State private var showWelcomeView: Bool = false  // State to trigger navigation

    // Check if the user is logged in by looking for the auth token
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "authToken") != nil
    }

    func toggleLikeStatus() {
        // Check if the user is logged in
        if !isUserLoggedIn() {
            // If not logged in, show WelcomeView
            showWelcomeView = true
            return
        }
        
        // Use the centralized API function
        APIService.shared.toggleLike(slug: post.slug) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let liked):
                    self.isLiked = liked  // Update the like status
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    var body: some View {
        // WebView for HTML content
        let cloudinaryBaseUrl = "https://res.cloudinary.com/dbm8xbouw/"
        let fullImageUrl = cloudinaryBaseUrl + post.featuredImage
        
        let htmlContent = """
        <html>
        <head>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 20px;
                    padding-bottom: 250px; /* Adds padding at the bottom of the page */
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
                .content, p, div, span {
                    font-size: 46px !important; 
                    margin-bottom: 16px;
                    line-height: 1.6;
                    padding-left: 10px; /* Add space on the left */
                    padding-right: 10px;
                }
                .views {
                    font-size: 36px;
                    color: #888;
                    text-align: center;
                }
        
                .banner {
                            margin: 40px 0;
                            padding: 20px;
                            text-align: center;
                            background-color: #FFD700;
                            border-radius: 20px;
                        }
                        .banner h2 {
                            font-size: 48px;
                            font-weight: bold;
                            margin-bottom: 16px;
                        }
                        .banner p {
                            font-size: 38px;
                            margin-bottom: 16px;
                        }
                        .banner a {
                            display: inline-block;
                            font-size: 48px;
                            padding: 20px 30px;
                            color: white;
                            background-color: green;
                            border-radius: 16px;
                            text-decoration: none;
                            margin-bottom: 40px; /* Adds space beneath the Donate button */
                        }
                        .banner a:hover {
                            background-color: darkgreen;
                        }
        
            </style>
        </head>
        <body>
            <h1>\(post.title)</h1>
            <img src="\(fullImageUrl)" alt="Featured Image">
            <p class="excerpt">\("Excerpt: \(post.excerpt)")</p>
            <div class="content">\(post.content)</div>
            <p class="views">Views: \(post.numberOfViews)</p>
        
        <!--
            <div class="banner">
                    <h2>Support Jessster!</h2>
                    <p>Show your appreciation to this platform by making a contribution. Every penny counts.</p>
                    <a href="https://www.jessster.com/donate">Donate</a>
                </div>
        -->
        </body>
        </html>
        """

        ZStack {
            // WebView for HTML content
            WebView(htmlContent: htmlContent)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Button(action: {
                        toggleLikeStatus() // Toggle like/unlike
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                            Text(isLiked ? "Unlike" : "Like")
                        }
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.footnote)
                    }
                    .padding()

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
        .background(
            NavigationLink(
                destination: WelcomeView(),
                isActive: $showWelcomeView,
                label: { EmptyView() }
            )
            .hidden()
        )
    }

    func sharePost() {
        guard let url = URL(string: "https://jessster.com/posts/\(post.slug)") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}

