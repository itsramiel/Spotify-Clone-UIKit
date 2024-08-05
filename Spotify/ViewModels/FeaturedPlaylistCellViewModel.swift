import Foundation

class FeaturedPlaylistCellViewModel {
    let name: String
    let artworkURL: URL?
    let creatorName: String

    init(name: String, artworkURL: URL? = nil, creatorName: String) {
        self.name = name
        self.artworkURL = artworkURL
        self.creatorName = creatorName
    }
}
