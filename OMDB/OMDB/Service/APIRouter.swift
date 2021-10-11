//
//  APIRouter.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter {
    case searchMovies(String, Int)
    case fetchMovie(String)
    
    var baseURL: String {
        switch self {
        case .searchMovies, .fetchMovie:
            return "https://www.omdbapi.com/?apikey=\(APISettings.apiKey)"
        }
    }
    
    var path: String {
        switch self {
        case .searchMovies(_, _):
            return ""
        case .fetchMovie(_ ):
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchMovies:
            return .get
        case .fetchMovie:
            return .get
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .searchMovies(let term, let page):
            return ["s": term, "page": String(page)]
        case .fetchMovie(let imdbId):
            return ["i": imdbId]
        }
    }
}

// MARK: - URLRequestConvertible
extension APIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder()
                .encode(parameters, into: request)
        } else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
