import Foundation

class AlbumTrackCellViewModel {
    let name: String
    let artistName: String

    init(name: String, artworkURL: URL? = nil, artistName: String) {
        self.name = name
        self.artistName = artistName
    }
}
