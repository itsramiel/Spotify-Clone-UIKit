//
//  Artist.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import Foundation

struct Artist: Codable {
    struct Followers: Codable {
        let total: Int
    }
    
    var externalUrls: [String: String]
    var href: String
    var id: String
    var name: String
    var type: String
    var uri: String
    let images: [Image]?
    let followers: Followers?
}
