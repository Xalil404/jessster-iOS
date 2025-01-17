//
//  CommentsView.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//
import SwiftUI


struct CommentsView: View {
    let postSlug: String // The post slug to fetch comments for
    @State private var comments: [Comment] = [] // List of comments for the article
    @State private var newComment: String = "" // Text input for new comment
    @State private var isLoading = false // Loading state for fetching comments
    @State private var errorMessage: String? = nil // Error message for any failures
    @State private var isAuthenticated: Bool = false // Check if the user is authenticated
    
    var body: some View {
        VStack {
            // Display loading spinner if fetching comments
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if comments.isEmpty {
                        // Empty state when no comments are available
                        VStack {
                            Text("No discussion yet.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top)
                            
                            Text("Be the first one to leave a comment.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top)

                            Image("sad")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350) // Adjust size as needed
                                .padding(.top, 16)
                        }
            } else {
                // Display comments if available
                List(comments.reversed()) { comment in
                    HStack {
                        // Display profile image next to the username
                        if let profileImageUrl = comment.profileImage, !profileImageUrl.isEmpty {
                            AsyncImage(url: URL(string: profileImageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        } else {
                            // Default image if no profile image
                            Image("jessster") // Ensure this image exists in your assets
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text(comment.username)
                                .font(.headline)
                            Text(comment.content)
                                .font(.body)
                                .padding(.top, 5)
                        }
                        .padding()
                    }
                }

            }
            
            Divider()
            
            // Input area for adding a new comment (disabled if not authenticated)
            if isAuthenticated {
                HStack {
                    TextField("Enter your comment...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        postComment()
                    }) {
                        Text("Post")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding()
            } else {
                Text("You need to be logged in to post a comment.")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            // Display error message if any
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            fetchComments()
            checkAuthentication()
        }
        .navigationTitle("Comments")
    }
    
    // Fetch comments from the API
    func fetchComments() {
        isLoading = true
        APIService.shared.fetchComments(postSlug: postSlug) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedComments):
                    comments = fetchedComments
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Post a new comment to the API
    func postComment() {
        APIService.shared.addComment(postSlug: postSlug, content: newComment) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    newComment = "" // Clear input field after successful post
                    fetchComments() // Refresh the comments list
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Check if user is authenticated
    func checkAuthentication() {
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(postSlug: "https://www.jessster.com/posts/tech-giant-introduces-new-feature-the-im-just-here-to-look-cool-mode")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
