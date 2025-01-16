//
//  APIService.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import Foundation

// Enum for API errors
enum APIError: Error {
    case invalidURL
    case noData
    case networkError(Error)
    case decodingError(Error)
    case unknownError
}

// Struct to decode the response for like functionality
struct LikeResponse: Decodable {
    let liked: Bool
    let likes_count: Int
}

class APIService {
    static let shared = APIService()  // Singleton instance

    private init() {}

    // Function to fetch posts based on language
    func fetchPosts(language: String, completion: @escaping (Result<[Post], APIError>) -> Void) {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/?language=\(language)"
        
        // Debugging: print the URL to check if it's correct
        print("Fetching posts from URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                var posts = try JSONDecoder().decode([Post].self, from: data)
                
                // Filter posts based on the selected language
                posts = posts.filter { $0.language == language }
                
                // Debugging: print the fetched and filtered posts
                print("Fetched and filtered posts: \(posts)")
                
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }



    // Function to fetch categories
    func fetchCategories(language: String, completion: @escaping (Result<[Category], APIError>) -> Void) {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/categories/?language=\(language)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let categories = try JSONDecoder().decode([Category].self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }


    // function to fetch videos
    func fetchVideos(language: String, completion: @escaping (Result<[Video], Error>) -> Void) {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/videos/"
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = [URLQueryItem(name: "lang", value: language)] // Pass language as a query parameter
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let videos = try JSONDecoder().decode([Video].self, from: data)
                completion(.success(videos))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // function to fetch posts by category
    func fetchPostsByCategory(categorySlug: String, language: String, completion: @escaping (Result<[Post], APIError>) -> Void) {
        // Adjust the URL to use category slug instead of category ID
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/?category=\(categorySlug)&language=\(language)"
        
        // Debugging: print the URL to check if it's correct
        print("Fetching posts for category \(categorySlug) from URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                
                // Debugging: print the fetched posts
                print("Fetched posts for category \(categorySlug): \(posts)")
                
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    // Function to fetch search results based on the query
    func fetchSearchResults(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        // Ensure the query is properly URL encoded
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid query string", code: 400, userInfo: nil)))
            return
        }

        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/search/?q=\(encodedQuery)"
        print("Fetching search results for query: \(encodedQuery) from URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }

            // Debugging: Print the raw response data
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(rawString)")
            }

            do {
                // Decode the data into a SearchResultsResponse object
                let decoder = JSONDecoder()
                let searchResultsResponse = try decoder.decode(SearchResultsResponse.self, from: data)
                completion(.success(searchResultsResponse.results))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // Function to fetch most viewed posts
       func fetchMostViewedPosts(language: String, completion: @escaping (Result<[Post], Error>) -> Void) {
           // Construct the query URL for fetching the posts, including language, sort, and order parameters
           let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/?sort_by=views&order=desc&language=\(language)"
           print("Fetching most viewed posts from URL: \(urlString)") // For debugging
           
           guard let url = URL(string: urlString) else {
               completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
               return
           }

           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                   return
               }
               
               // Debugging: Print the raw response data
               if let rawString = String(data: data, encoding: .utf8) {
                   print("Raw response data: \(rawString)")
               }

               do {
                   let decoder = JSONDecoder()
                   let posts = try decoder.decode([Post].self, from: data) // Decoding the response to Post model
                   completion(.success(posts))  // Return the posts array
               } catch {
                   completion(.failure(error))
               }
           }

           task.resume()
       }
    
    // Function to fetch most liked posts
    func fetchMostLikedPosts(language: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Construct the query URL for fetching the posts, including language, sort, and order parameters
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/?sort_by=likes&order=desc&language=\(language)"
        print("Fetching most liked posts from URL: \(urlString)") // For debugging
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            // Debugging: Print the raw response data
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(rawString)")
            }

            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data) // Decoding the response to Post model
                completion(.success(posts))  // Return the posts array
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    // Function to fetch most commented posts
    func fetchMostCommentedPosts(language: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Construct the query URL for fetching the posts, including language, sort, and order parameters
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/?sort_by=comments&order=desc&language=\(language)"
        print("Fetching most commented posts from URL: \(urlString)") // For debugging
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            // Debugging: Print the raw response data
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(rawString)")
            }

            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data) // Decoding the response to Post model
                completion(.success(posts))  // Return the posts array
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

        // Fetch Comments for a specific post (allow unauthenticated access)
        func fetchComments(postSlug: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
            guard let url = URL(string: "https://jessster-476efeac7498.herokuapp.com/api/posts/\(postSlug)/comments/") else {
                completion(.failure(APIError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Allow unauthenticated access
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(APIError.networkError(error)))
                    return
                }

                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }

                // Check if the response status code is valid
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let comments = try JSONDecoder().decode([Comment].self, from: data)
                        completion(.success(comments))
                    } catch {
                        completion(.failure(APIError.decodingError(error)))
                    }
                } else {
                    completion(.failure(APIError.unknownError))
                }
            }.resume()
        }

        // Post a new comment (only for authenticated users)
        func addComment(postSlug: String, content: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let token = UserDefaults.standard.string(forKey: "authToken"),
                  let url = URL(string: "https://jessster-476efeac7498.herokuapp.com/api/posts/\(postSlug)/comments/") else {
                completion(.failure(APIError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Include post ID along with content in the body
            let body: [String: Any] = [
                "content": content,
                // Assuming the `post` field is the post ID in the backend
                "post": postSlug
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(APIError.networkError(error)))
                    return
                }

                // Check if the response status code indicates success
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else {
                    completion(.failure(APIError.unknownError))
                }
            }.resume()
        }
    
    // Fetch liked posts from the API
    func fetchLikedPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/user/liked-articles/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Assuming the user is authenticated and has a valid token
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                // Decode the response into an array of Post objects
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))  // Return the list of liked posts
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    

    // Function to toggle like status for a post
    func toggleLike(slug: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/\(slug)/like/"
        
        print("Toggling like at URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
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
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                // Decode the response into LikeResponse struct
                let result = try JSONDecoder().decode(LikeResponse.self, from: data)
                completion(.success(result.liked))  // Return whether the post was liked/unliked
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }

    
}







    

