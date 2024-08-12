struct Playlist: Codable {
    struct PlaylistOwner: Codable {
        let displayName: String
        let externalUrls: [String: String]
        let href: String
        let id: String
        let type: String
        let uri: String
    }

    struct PlaylistTrack: Codable {
        let href: String
        let total: Int
    }

    let collaborative: Bool
    let description: String
    let externalUrls: [String: String]
    let href: String
    let id: String
    let images: [
        Image
    ]
    let name: String
    let owner: PlaylistOwner
    let primaryColor: String?
    let isPublic: Bool?
    let snapshotId: String
    let tracks: PlaylistTrack
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case collaborative
        case description
        case externalUrls
        case href
        case id
        case images
        case name
        case owner
        case primaryColor
        case snapshotId
        case tracks
        case type
        case uri
    }
}
