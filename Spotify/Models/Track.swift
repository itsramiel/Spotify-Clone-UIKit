struct Track: Codable {
    struct Album: Codable {
        let albumType: String
        let artists: [Artist]
        let availableMarkets: [String]
        let externalUrls: [String: String]
        let href: String
        let id: String
        let images: [Image]
        let name: String
        let releaseDate: String
        let releaseDatePrecision: String
        let totalTracks: Int
        let type: String
        let uri: String
    }

    struct Artist: Codable {
        let externalUrls: [String: String]
        let href: String
        let id: String
        let name: String
        let type: String
        let uri: String
    }

    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalIds: [String: String]
    let externalUrls: [String: String]
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String
}
