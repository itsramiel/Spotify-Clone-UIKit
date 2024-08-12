import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let message: String
    let playlists: PaginatedResponse<Playlist>
}
