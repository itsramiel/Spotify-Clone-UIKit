struct Track: Codable {
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
    var album: Album?
    let artists: [Artist]
    let discNumber, durationMs, trackNumber: Int
    let externalUrls: [String: String]
    let href: String
    let id, name: String
    let uri: String
    let isLocal: Bool
}
