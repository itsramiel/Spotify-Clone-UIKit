//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Rami Elwan on 29.07.24.
//

import Foundation

struct NewReleasesResponse: Codable {
    struct Artist: Codable {
        var externalUrls: [String: String]
        var href: String
        var id: String
        var name: String
        var type: String
        var uri: String
    }

    struct Album: Codable {
        let albumType: String
        let totalTracks: Int
        let availableMarkets: [String]
        let externalUrls: [String: String]
        let href: String
        let id: String
        let images: [Image]
        let name: String
        let releaseDate: String
        let releaseDatePrecision: String
        let restrictions: [String: String]
        let type: String
        let uri: String
        let artists: [Artist]
    }

    struct Albums: Codable {
        var href: String
        var limit: Int
        var next: String
        var offset: Int
        var previous: String
        var total: Int
        var items: [Album]
    }

    let albums: Albums
}
