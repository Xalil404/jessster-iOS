//
//  Search.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//
import Foundation

// Model for search results (adjust to fit your actual data structure)

struct SearchResult: Identifiable, Decodable {
    let id: Int
    let title: String
    let slug: String
    let author: String
    let featuredImage: String
    let excerpt: String
    let content: String
    let status: Int
    let category: Category
    let language: String
    let numberOfViews: Int
    let likesCount: Int
    let commentCount: Int
    let createdOn: String
    let updatedOn: String
    
    // JSON keys to match the API response keys
    enum CodingKeys: String, CodingKey {
        case id, title, slug, author, category, language, status
        case featuredImage = "featured_image"
        case excerpt, content
        case numberOfViews = "number_of_views"
        case likesCount = "likes_count"
        case commentCount = "comment_count"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}


struct SearchResultsResponse: Decodable {
    let results: [SearchResult]
}
