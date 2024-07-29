//
//  AuthResponse.swift
//  Spotify
//
//  Created by Rami Elwan on 25.07.24.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
}
