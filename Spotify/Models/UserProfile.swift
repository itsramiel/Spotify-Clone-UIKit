//
//  UserProfile.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import Foundation

struct UserProfile: Codable {
    let displayName: String
    let externalUrls: [String: String]
    let href: String
    let id: String
    let images: [UserProfileImage]
    let type: String
    let country: String
    let product: String
}


struct UserProfileImage:Codable {
    let url: String
    let height: Int
    let width: Int
}
