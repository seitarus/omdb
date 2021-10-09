//
//  MoviesResponse.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

struct MoviesResponse : Codable {
	let search : [Movie]?
	let totalResults : String?
	let response : String?
	
	enum CodingKeys: String, CodingKey {

		case search = "Search"
		case totalResults = "totalResults"
		case response = "Response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        search = try values.decodeIfPresent([Movie].self, forKey: .search)
        totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
        response = try values.decodeIfPresent(String.self, forKey: .response)
		
	}

}
