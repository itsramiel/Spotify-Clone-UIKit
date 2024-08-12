//
//  PaginatedResponse.swift
//  Spotify
//
//  Created by Rami Elwan on 10.08.24.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let href: String
    let items: [T]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
