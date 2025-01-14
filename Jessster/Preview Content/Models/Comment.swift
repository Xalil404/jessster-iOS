//
//  Comment.swift
//  Jessster
//
//  Created by TEST on 14.01.2025.
//

import Foundation

struct Comment: Identifiable, Decodable {
    let id: Int
    let post: Int
    let user: Int
    let content: String
    let createdOn: String
    let updatedOn: String
    let parentComment: Int?
    let username: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case post
        case user
        case content
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case parentComment = "parent_comment"
        case username
        case profileImage = "profile_image"
    }
}

