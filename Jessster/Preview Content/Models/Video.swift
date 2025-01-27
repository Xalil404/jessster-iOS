//
//  Video.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import Foundation

struct Video: Identifiable, Codable {
    var id: Int
    var title: String
    var video: String?  // URL path for the video that is optional
    var description: String
    var createdAt: String
    var language: String
    var status: Int
    
    // Custom coding keys for the response format
    enum CodingKeys: String, CodingKey {
        case id, title, video, description, language, status
        case createdAt = "created_at"
    }
}

/* Model that uses Cloudinary Videos
import Foundation

struct Video: Identifiable, Codable {
    var id: Int
    var title: String
    var video: String  // URL path for the video
    var description: String
    var createdAt: String
    var language: String
    var status: Int
    
    // Custom coding keys for the response format
    enum CodingKeys: String, CodingKey {
        case id, title, video, description, language, status
        case createdAt = "created_at"
    }
}
*/
