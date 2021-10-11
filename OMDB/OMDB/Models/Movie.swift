//
//  Movie.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation
// TopStories
struct Movie : Codable {
	let title, year, rated, released: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards: String?
    let poster: String?
    let ratings: [Rating]?
    let metascore, imdbRating, imdbVotes, imdbID: String?
    let type, dvd, boxOffice, production: String?
    let website, response: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
        case error = "Error"
    }

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		title      = try container.decodeIfPresent(String.self, forKey: .title)
		year       = try container.decodeIfPresent(String.self, forKey: .year)
        rated      = try container.decodeIfPresent(String.self, forKey: .rated)
        released   = try container.decodeIfPresent(String.self, forKey: .released)
        runtime    = try container.decodeIfPresent(String.self, forKey: .runtime)
        genre      = try container.decodeIfPresent(String.self, forKey: .genre)
        director   = try container.decodeIfPresent(String.self, forKey: .director)
        writer     = try container.decodeIfPresent(String.self, forKey: .writer)
        actors     = try container.decodeIfPresent(String.self, forKey: .actors)
        plot       = try container.decodeIfPresent(String.self, forKey: .plot)
        language   = try container.decodeIfPresent(String.self, forKey: .language)
        country    = try container.decodeIfPresent(String.self, forKey: .country)
        awards     = try container.decodeIfPresent(String.self, forKey: .awards)
        poster     = try container.decodeIfPresent(String.self, forKey: .poster)
        ratings    = try container.decodeIfPresent([Rating].self, forKey: .ratings)
        metascore  = try container.decodeIfPresent(String.self, forKey: .metascore)
        imdbRating = try container.decodeIfPresent(String.self, forKey: .imdbRating)
        imdbVotes  = try container.decodeIfPresent(String.self, forKey: .imdbVotes)
		imdbID     = try container.decodeIfPresent(String.self, forKey: .imdbID)
		type       = try container.decodeIfPresent(String.self, forKey: .type)
        dvd        = try container.decodeIfPresent(String.self, forKey: .dvd)
        boxOffice  = try container.decodeIfPresent(String.self, forKey: .boxOffice)
        production = try container.decodeIfPresent(String.self, forKey: .production)
        website    = try container.decodeIfPresent(String.self, forKey: .website)
        response   = try container.decodeIfPresent(String.self, forKey: .response)
        error      = try container.decodeIfPresent(String.self, forKey: .error)
	}

}


// MARK: - Rating
struct Rating: Codable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
