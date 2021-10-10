//
//  MovieShort.swift
//  OMDB
//
//  Created by iMac 27 iOS on 10/10/21.
//

import Foundation

struct MovieShort: Codable {
    let title, year, imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
}
