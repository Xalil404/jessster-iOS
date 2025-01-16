//
//  VideoTabView.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
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
        NavigationView { // Add a NavigationView here
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
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Russian").tag("ru")
                    Text("Arabic").tag("ar")
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
                        ScrollView(.vertical, showsIndicators: false) {  // Change to vertical scroll
                            VStack(spacing: 8) {  // Adjust spacing between video items
                                ForEach(videos.indices, id: \.self) { index in
                                    VStack(spacing: 4) {  // Reduce the space between each video item
                                        // Video Player
                                        VideoPlayerView(videoUrl: videos[index].video)
                                            .frame(height: 300) // Set height for the video
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
                                        .padding(.top, 8)
                                    }
                                    .padding([.leading, .trailing], 8)  // Reduce the horizontal padding for each video
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



/* code without a share video button
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
        NavigationView { // Add a NavigationView here
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
                
                // Segmented control for language selection
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Russian").tag("ru")
                    Text("Arabic").tag("ar")
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
                        ScrollView(.vertical, showsIndicators: false) {  // Change to vertical scroll
                            VStack(spacing: 8) {  // Adjust spacing between video items
                                ForEach(videos.indices, id: \.self) { index in
                                    VStack(spacing: 4) {  // Reduce the space between each video item
                                        // Video Player
                                        VideoPlayerView(videoUrl: videos[index].video)
                                            .frame(height: 300) // Set height for the video
                                        
                                        // Video Title
                                        //Text(videos[index].title)
                                            .font(.headline)
                                            .padding(.top, 4)
                                        
                                        // Video Description
                                        //Text(videos[index].description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 4)
                                        
                                        // Posted Date
                                        //Text("Posted on \(videos[index].createdAt)")
                                            .font(.caption)
                                            .padding(.bottom, 4)
                                    }
                                    .padding([.leading, .trailing], 8)  // Reduce the horizontal padding for each video
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
