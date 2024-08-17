// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playlistDetail = try? JSONDecoder().decode(PlaylistDetail.self, from: jsonData)

import Foundation

// MARK: - PlaylistDetail

struct PlaylistDetail: Codable {
    // MARK: - Followers

    struct Followers: Codable {
        let href: String?
        let total: Int
    }

    // MARK: - Owner

    struct Owner: Codable {
        let displayName: String?
        let externalUrls: [String: String]
        let href: String
        let id: String
        let type: OwnerType
        let uri: String
        let name: String?
    }

    enum OwnerType: String, Codable {
        case artist
        case user
    }


    // MARK: - Item

    struct Item: Codable {
        let addedAt: String
        let addedBy: Owner
        let isLocal: Bool
        let primaryColor: String?
        let track: Track
    }


    // MARK: - Album

    struct Album: Codable {
        let availableMarkets: [String]
        let type, albumType: String
        let href: String
        let id: String
        let images: [Image]?
        let name, releaseDate: String
        let releaseDatePrecision: String
        let uri: String
        let artists: [Owner]
        let externalUrls: [String: String]
        let totalTracks: Int
    }


    // MARK: - ExternalIDS

    struct ExternalIDS: Codable {
        let isrc: String
    }

    enum TrackType: String, Codable {
        case track
    }

    let collaborative: Bool?
    let description: String
    let externalUrls: [String: String]
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]?
    let name: String
    let owner: Owner
    let primaryColor: String?
    let snapshotId: String
    let tracks: PaginatedResponse<Item>
    let type, uri: String
}
