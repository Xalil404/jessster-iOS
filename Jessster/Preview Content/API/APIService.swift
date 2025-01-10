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
        let urlString = "https://jessster-476efeac7498.herokuapp.com/api/posts/"
        
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
}
