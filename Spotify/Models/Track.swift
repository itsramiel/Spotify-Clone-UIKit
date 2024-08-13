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

    let previewUrl: String?
    let availableMarkets: [String]
    let explicit: Bool
    let type: String
    let album: Album?
    let artists: [Artist]
    let discNumber, durationMs, trackNumber: Int
    let externalUrls: [String: String]
    let href: String
    let id, name: String
    let uri: String
    let isLocal: Bool
}
