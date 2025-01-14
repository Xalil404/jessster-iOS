//
//  SettingsView.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//
import SwiftUI
import SafariServices

struct SettingsView: View {
    @State private var selectedURL: URL? // URL to open in the web view
    @State private var showWebView = false // Controls whether the web view is shown
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Settings")) {
                    Button("About") {
                        print("About button tapped")
                        if let url = URL(string: "https://www.jessster.com/about") {
                            print("Setting About URL: \(url)")
                            selectedURL = url
                        }
                        showWebView = true
                    }
                    Button("Donate") {
                        print("Donate button tapped")
                        if let url = URL(string: "https://www.jessster.com/donate") {
                            print("Setting Donate URL: \(url)")
                            selectedURL = url
                        }
                        showWebView = true
                    }
                    Button("Contact") {
                        print("Contact button tapped")
                        if let url = URL(string: "https://www.jessster.com/contact") {
                            print("Setting Contact URL: \(url)")
                            selectedURL = url
                        }
                        showWebView = true
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showWebView) {
                if let url = selectedURL {
                    SafariViewControllerWrapper(url: url)
                } else {
                    Text("URL not available")
                }
            }
        }
    }
}

struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        print("Loading URL: \(url)")  // Debug print statement
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Nothing to update
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}




/*
import SwiftUI
import SafariServices

struct SettingsView: View {
    @State private var selectedURL: URL? // URL to open in the web view
    @State private var showWebView = false // Controls whether the web view is shown
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Settings")) {
                    Button("About") {
                        print("About button tapped")
                        selectedURL = URL(string: "https://www.jessster.com/about")
                        showWebView = true
                    }
                    Button("Donate") {
                        print("Donate button tapped")
                        selectedURL = URL(string: "https://www.jessster.com/donate")
                        showWebView = true
                    }
                    Button("Contact") {
                        print("Contact button tapped")
                        selectedURL = URL(string: "https://www.jessster.com/contact")
                        showWebView = true
                    }
                }
            }
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showWebView) {
                // Make sure URL is not nil
                if let url = selectedURL {
                    SafariViewControllerWrapper(url: url)
                } else {
                    Text("URL not available")
                }
            }
        }
    }
}

struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        print("Loading URL: \(url)")  // Debug print statement
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Nothing to update
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

*/
