import Foundation

class RecommendedTrackCellViewModel {
    let name: String
    let artworkURL: URL?
    let artistName: String

    init(name: String, artworkURL: URL? = nil, artistName: String) {
        self.name = name
        self.artworkURL = artworkURL
        self.artistName = artistName
    }
}
