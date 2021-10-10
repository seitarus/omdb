//
//  MoviesResponse.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

struct MoviesResponse: Codable {
    let search: [MovieShort]?
    let totalResults: String?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        search       = try container.decodeIfPresent([MovieShort].self, forKey: .search)
        totalResults = try container.decodeIfPresent(String.self, forKey: .totalResults)
        response     = try container.decode(String.self, forKey: .response)
        error        = try container.decodeIfPresent(String.self, forKey: .error)
    }
}
