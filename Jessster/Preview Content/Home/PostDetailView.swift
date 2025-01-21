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


/* liked and unliked posts are saved unsaved but for not logged in users; nothing happens
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

    // Toggle the like/unlike status using the existing function
    func toggleLikeStatus() {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/\(post.slug)/like/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Assuming the user is authenticated and has a valid token
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                // Decode the response into LikeResponse struct
                let result = try JSONDecoder().decode(LikeResponse.self, from: data)
                DispatchQueue.main.async {
                    self.isLiked = result.liked  // Update the like status
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }

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
                        toggleLikeStatus() // Call the toggle function when button is pressed
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart") // Heart icon based on like status
                            Text(isLiked ? "Unlike" : "Like")
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
*/



/* Original code without like functionality
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

*/

























