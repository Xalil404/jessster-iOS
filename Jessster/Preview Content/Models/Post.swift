//
//  Post.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//
import Foundation

struct Post: Identifiable, Decodable {
    var id: Int
    var title: String
    var slug: String
    var author: String
    var featuredImage: String
    var excerpt: String
    var content: String
    var status: Int
    var category: Category
    var language: String
    var numberOfViews: Int
    var likesCount: Int
    var commentCount: Int
    var isLiked: Bool  // Add this property
    var createdOn: String
    var updatedOn: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case slug
        case author
        case featuredImage = "featured_image"
        case excerpt
        case content
        case status
        case category
        case language
        case numberOfViews = "number_of_views"
        case likesCount = "likes_count"
        case commentCount = "comment_count"
        case isLiked = "is_liked"  // Map to backend field
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}


