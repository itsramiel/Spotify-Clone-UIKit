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

    // MARK: - Tracks

    struct Tracks: Codable {
        let href: String
        let items: [Item]
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
    }

    // MARK: - Item

    struct Item: Codable {
        let addedAt: String
        let addedBy: Owner
        let isLocal: Bool
        let primaryColor: String?
        let track: Track
    }

    // MARK: - Track

    struct Track: Codable {
        let previewUrl: String?
        let availableMarkets: [String]
        let explicit: Bool
        let type: TrackType
        let episode, track: Bool
        let album: Album
        let artists: [Owner]
        let discNumber, trackNumber, durationMs: Int
        let externalIds: ExternalIDS
        let externalUrls: [String: String]
        let href: String
        let id, name: String
        let popularity: Int
        let uri: String
        let isLocal: Bool
    }

    // MARK: - Album

    struct Album: Codable {
        let availableMarkets: [String]
        let type, albumType: AlbumTypeEnum
        let href: String
        let id: String
        let images: [Image]
        let name, releaseDate: String
        let releaseDatePrecision: ReleaseDatePrecision
        let uri: String
        let artists: [Owner]
        let externalUrls: [String: String]
        let totalTracks: Int
    }

    enum AlbumTypeEnum: String, Codable {
        case album
        case single
    }

    enum ReleaseDatePrecision: String, Codable {
        case day
    }

    // MARK: - ExternalIDS

    struct ExternalIDS: Codable {
        let isrc: String
    }

    enum TrackType: String, Codable {
        case track
    }

    let collaborative: Bool
    let description: String
    let externalUrls: [String: String]
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let primaryColor: String
    let snapshotId: String
    let tracks: Tracks
    let type, uri: String
}
