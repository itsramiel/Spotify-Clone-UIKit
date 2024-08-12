//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Rami Elwan on 29.07.24.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: PaginatedResponse<Album>
}
