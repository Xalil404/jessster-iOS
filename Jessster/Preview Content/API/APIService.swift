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


}
