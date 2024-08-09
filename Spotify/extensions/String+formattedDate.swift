//
//  String+formattedDate.swift
//  Spotify
//
//  Created by Rami Elwan on 08.08.24.
//

import Foundation

extension String {
    private static let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    private static let displayDateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    static func formattedDate(string: String) -> String {
        guard let date = String.dateFormatter.date(from: string) else { return string}
        return String.displayDateFormatter.string(from: date)
    }
}
