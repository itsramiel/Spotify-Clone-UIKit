//
//  AlbumDetail.swift
//  Spotify
//
//  Created by Rami Elwan on 08.08.24.
//

import Foundation

import Foundation

struct AlbumDetail: Codable {
    struct Track: Codable {
        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber: Int
        let durationMs: Int
        let explicit: Bool
        let externalUrls: [String:String]
        let href: String
        let id: String
        let name: String
        let previewUrl: String
        let trackNumber: Int
        let type: String
        let uri: String
        let isLocal: Bool
    }
    
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
    let type: String
    let uri: String
    let tracks: PaginatedResponse<Track>
    let artists: [Artist]
    let restrictions: [String: String]?
    let genres: [String]
    let label: String
    let popularity: Int
}
