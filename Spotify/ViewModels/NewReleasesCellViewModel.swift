import Foundation

class NewReleasesCellViewModel {
    let name: String
    let artworkURL: URL?
    let numberOfTracks: Int
    let artistName: String

    init(name: String, artworkURL: URL?, numberOfTracks: Int, artistName: String) {
        self.name = name
        self.artworkURL = artworkURL
        self.numberOfTracks = numberOfTracks
        self.artistName = artistName
    }
}
