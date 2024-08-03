import Foundation

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
    let restrictions: [String: String]?
    let type: String
    let uri: String
    let artists: [Artist]
}
