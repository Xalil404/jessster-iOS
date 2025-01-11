//
//  Category.swift
//  Jessster
//
//  Created by TEST on 10.01.2025.
//

import Foundation

struct Category: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let language: String
    let slug: String
}
