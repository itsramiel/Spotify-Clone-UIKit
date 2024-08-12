//
//  SearchResult.swift
//  Spotify
//
//  Created by Rami Elwan on 10.08.24.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: Track)
    case playlist(model: Playlist)
}
