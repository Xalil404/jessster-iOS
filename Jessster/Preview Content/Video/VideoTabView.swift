//
//  VideoTabView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import SwiftUI
import WebKit
import SwiftSoup

// WebView to render HTML content (including embedded video or description)
struct VideoWebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false // Optional: Disable scrolling
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Inject CSS for cropping
        let styledContent = """
        <html>
        <head>
        <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        iframe {
            width: 100vw;
            height: 100vh;
            object-fit: cover;
            clip-path: inset(0 15%); /* Crop 20% from left and right */
        }
        </style>
        </head>
        <body>
        \(htmlContent)
        </body>
        </html>
        """
        uiView.loadHTMLString(styledContent, baseURL: nil)
    }
}

struct VideoTabView: View {
    @State private var videos: [Video] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var selectedLanguage = "en"  // Default language is English
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode

    // Function to extract video URL from HTML content
    func extractVideoURL(from htmlContent: String) -> String? {
        do {
            let document = try SwiftSoup.parse(htmlContent)
            if let iframe = try document.select("iframe").first() {
                return try iframe.attr("src")
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return nil
    }

    // Share video function
    func shareVideo(_ video: Video) {
        let videoURLString: String?
        
        if let directVideoURL = video.video {
            videoURLString = directVideoURL
        } else {
            videoURLString = extractVideoURL(from: video.description)
        }
        
        guard let urlString = videoURLString, let videoURL = URL(string: urlString) else {
            print("No valid video URL found.")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        
        if let rootController = UIApplication.shared.windows.first?.rootViewController {
            rootController.present(activityVC, animated: true, completion: nil)
        }
    }

    // Fetch videos based on language
    func fetchVideos(language: String) {
        isLoading = true
        APIService.shared.fetchVideos(language: language) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let videos):
                    self.videos = videos
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Logo Header
                HStack {
                    Spacer()
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                    
                    // Simplified search NavigationLink
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Spacer()
                }
                .padding(.top, 1)
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    Text("عربي").tag("ar")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { newLanguage in
                    fetchVideos(language: newLanguage)  // Fetch videos when the language changes
                }

                if isLoading {
                    ProgressView("Loading videos...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(videos) { video in
                                VideoWebView(htmlContent: video.description)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6) // Portrait ratio
                                    .cornerRadius(8)
                                    .padding(.vertical, 8)
                                    
                                
                                // Share Button
                                Button(action: {
                                    shareVideo(video)
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up") // Share icon
                                            .foregroundColor(colorScheme == .dark ? .white : .black) // Icon color
                                        Text("Share Video")
                                            .font(.system(size: 16))
                                            .foregroundColor(colorScheme == .dark ? .white : .black) // Text color
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue.opacity(0.1)) // Background color
                                    .cornerRadius(8)
                                }

                            }
                        }
                        .padding(.horizontal) // Optional padding
                    }
                }

            }
            .onAppear {
                fetchVideos(language: selectedLanguage) // Fetch videos on initial load based on the default language
            }
        }
    }
}

struct VideoTabView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTabView()
    }
}


/* fully working code without share button
import SwiftUI
import WebKit

// WebView to render HTML content (including embedded video or description)
struct VideoWebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false  // Optional: Disable scrolling
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Inject CSS for cropping
        let styledContent = """
        <html>
        <head>
        <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        iframe {
            width: 100vw;
            height: 100vh;
            object-fit: cover;
            clip-path: inset(0 10%); /* Crop 20% from left and right */
        }
        </style>
        </head>
        <body>
        \(htmlContent)
        </body>
        </html>
        """
        uiView.loadHTMLString(styledContent, baseURL: nil)
    }
}


struct VideoTabView: View {
    @State private var videos: [Video] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var selectedLanguage = "en"  // Default language is English
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode

    // Fetch videos based on language
    func fetchVideos(language: String) {
        isLoading = true
        APIService.shared.fetchVideos(language: language) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let videos):
                    self.videos = videos
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Logo Header
                HStack {
                    Spacer()
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                    
                    // Simplified search NavigationLink
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Spacer()
                }
                .padding(.top, 1)
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    Text("عربي").tag("ar")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { newLanguage in
                    fetchVideos(language: newLanguage)  // Fetch videos when the language changes
                }

                if isLoading {
                    ProgressView("Loading videos...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(videos) { video in
                                VideoWebView(htmlContent: video.description)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6) // Portrait ratio
                                    .cornerRadius(8)
                                    .padding(.vertical, 8)
                                
                            }
                        }
                        .padding(.horizontal) // Optional padding
                    }
                }

            }
            .onAppear {
                fetchVideos(language: selectedLanguage) // Fetch videos on initial load based on the default language
            }
        }
    }
}

struct VideoTabView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTabView()
    }
}
*/

/* Original code serving google drive videos
import SwiftUI
import WebKit

// WebView to render HTML content (including embedded video or description)
struct VideoWebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Load the HTML content directly
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct VideoTabView: View {
    @State private var videos: [Video] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var selectedLanguage = "en"  // Default language is English
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode

    // Fetch videos based on language
    func fetchVideos(language: String) {
        isLoading = true
        APIService.shared.fetchVideos(language: language) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let videos):
                    self.videos = videos
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Logo Header
                HStack {
                    Spacer()
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                    
                    // Simplified search NavigationLink
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Spacer()
                }
                .padding(.top, 1)
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    Text("عربي").tag("ar")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { newLanguage in
                    fetchVideos(language: newLanguage)  // Fetch videos when the language changes
                }

                if isLoading {
                    ProgressView("Loading videos...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(videos) { video in
                                VideoWebView(htmlContent: video.description)
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    .padding(.vertical, 8)
                            }
                        }
                        .padding(.horizontal) // Optional padding
                    }
                }

            }
            .onAppear {
                fetchVideos(language: selectedLanguage) // Fetch videos on initial load based on the default language
            }
        }
    }
}

struct VideoTabView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTabView()
    }
}
*/



/* Code to Fetch videos from Cloudinary
import SwiftUI
import AVKit
import AVFoundation

struct VideoTabView: View {
    @State private var selectedLanguage = "en"  // Default language is English
    @State private var videos: [Video] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var currentIndex = 0  // Track the current video index
    @State private var showSearch = false // To track the search screen navigation
    @Environment(\.colorScheme) var colorScheme  // Access the color scheme for light/dark mode
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo Header
                HStack {
                    Spacer()
                    Image(colorScheme == .dark ? "TheJesssterTimesLogoDark" : "TheJesssterTimesLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50) // Adjust the height of the logo
                        .padding(.leading, 46) // Custom padding
                    NavigationLink(destination: SearchView(), isActive: $showSearch) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .padding()
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Spacer()
                }
                .padding(.top, 1)
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    Text("عربي").tag("ar")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Loading state for videos
                if isLoading {
                    ProgressView("Loading Videos...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Display video player and other video details
                    if !videos.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 8) {
                                ForEach(videos.indices, id: \.self) { index in
                                    VStack(spacing: 4) {
                                        // Lazy loading of videos (only when visible)
                                        VideoPlayerView(videoUrl: videos[index].video)
                                            .frame(height: 300)
                                        
                                        /*
                                        // Video Title
                                        Text(videos[index].title)
                                            .font(.headline)
                                            .padding(.top, 4)
                                        
                                        // Video Description
                                        Text(videos[index].description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 4)
                                        */
                                        
                                        // Share Button
                                        ShareLink(item: URL(string: "https://res.cloudinary.com/dbm8xbouw/\(videos[index].video)")!) {
                                            Label("Share Video", systemImage: "square.and.arrow.up")
                                        }
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .padding(.top, 8)
                                    }
                                    .padding([.leading, .trailing], 8)
                                }
                            }
                        }
                    } else {
                        Text("No videos available.")
                    }
                }
                
                Spacer()
            }
            .onAppear {
                // Set up the audio session before the video plays
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
                    try? AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Failed to set up audio session: \(error)")
                }
                
                fetchVideos()
            }
            .onChange(of: selectedLanguage) { _ in
                fetchVideos()
            }
        }
    }
    
    private func fetchVideos() {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.fetchVideos(language: selectedLanguage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedVideos):
                    self.videos = fetchedVideos
                case .failure(let error):
                    self.errorMessage = "Failed to load videos: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct VideoPlayerView: View {
    var videoUrl: String
    
    var body: some View {
        if let url = URL(string: "https://res.cloudinary.com/dbm8xbouw/\(videoUrl)") {
            AVPlayerViewControllerRepresented(player: AVPlayer(url: url))
                .frame(height: 300)
        } else {
            Text("Invalid Video URL")
                .padding()
        }
    }
}

struct AVPlayerViewControllerRepresented: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        playerViewController.videoGravity = .resizeAspectFill // Ensures proper aspect ratio for portrait videos
        playerViewController.player?.isMuted = false  // Ensure the sound is on
        
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Optional: Update the view controller when the player changes
        uiViewController.player = player
    }
}

struct VideoTabView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTabView()
    }
}
*/
