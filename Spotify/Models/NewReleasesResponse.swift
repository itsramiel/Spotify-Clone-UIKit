//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Rami Elwan on 29.07.24.
//

import Foundation

struct NewReleasesResponse: Codable {
    struct Albums: Codable {
        var href: String
        var limit: Int
        var next: String?
        var offset: Int
        var previous: String?
        var total: Int
        var items: [Album]
    }

    let albums: Albums
}
