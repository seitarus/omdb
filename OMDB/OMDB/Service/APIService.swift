//
//  APIService.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    
    func searchMovies(for name: String, page: Int, complete: @escaping ( _ movies: [MovieShort], _ total: Int, _ error: Error? )->() )
    func fetchMovie(by imdbId: String, complete: @escaping ( _ movie: Movie?, _ error: Error? )->() )
    
}

struct APIService: APIServiceProtocol {
      
    func searchMovies(for name: String, page: Int, complete: @escaping ( [MovieShort], Int, Error?) -> ()) {
        
        AF.request(APIRouter.searchMovies(name, page)).validate()
          .responseDecodable(of: MoviesResponse.self) { response in
              
              // Controlar error en la respuesta
              if let error = response.error {
                  return complete( [], 0, error)
              }
              
              // Controlar que la API devuelva contenido
              guard let result = response.value else { return complete( [], 0, nil) }
            
              guard let list = result.search else {
                  
                  if let error = result.error {
                      // La peticion es correcta pero no hay resultados de la busqueda
                                            
                      return complete( [], 0, NSError(domain: "", code: 401, userInfo: [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Not Found", value: error, comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Not Found", value: error, comment: "")
                        ]))
                  }
                  
                  return complete( [], 0, NSError(domain: "", code: 401, userInfo: [
                    NSLocalizedDescriptionKey :  NSLocalizedString("No Results", value: "No results", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("No Results", value: "No results", comment: "")
                    ]))
              }
              
              var total = 1
              if let totalResults = result.totalResults {
                  total = Int(totalResults) ?? 1
              }
                        

              complete( list, total, nil)
        }
        
    }
    
    func fetchMovie(by imdbId: String, complete: @escaping (Movie?, Error?) -> ()) {
        
        AF.request(APIRouter.fetchMovie(imdbId)).validate()
            .responseDecodable(of: Movie.self) { response in
                
                // Controlar error en la respuesta
                if let error = response.error {
                    return complete( nil, error)
                }
                
                // Controlar que la API devuelva contenido
                guard let movie = response.value else { return complete( nil, nil) }
                
                if let error = movie.error {
                    // La peticion es correcta pero no se ha encontrado el elemento
                    
                    return complete( nil, NSError(domain: "", code: 401, userInfo: [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Not Found", value: error, comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Not Found", value: error, comment: "")
                    ]))
                }
                
                complete( movie, nil)
            }
    }

}
