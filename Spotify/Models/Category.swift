//
//  Category.swift
//  Spotify
//
//  Created by Rami Elwan on 09.08.24.
//

import Foundation

struct Category: Codable {
    struct Icon: Codable {
        let url: String
    }
    
    let href: String
    let id: String
    let icons: [Icon]
    let name: String
}
