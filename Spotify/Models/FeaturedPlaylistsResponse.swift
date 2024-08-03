import Foundation

struct FeaturedPlaylistsResponse: Codable {
    struct Playlists: Codable {
        let href: String
        let items: [Playlist]
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
    }

    let message: String
    let playlists: Playlists
}
