//
//  APIService.swift
//  OMDB
//
//  Created by iMac 27 iOS on 9/10/21.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    
    func searchMovies(for name: String, complete: @escaping ( _ movies: [MovieShort], _ error: Error? )->() )
    
}

class UrlComponents {
    
    let path: String
    let baseUrlString = "https://www.omdbapi.com/?"
    let apiKey = "5681b4b6"
    let searchQuery: String?
    
    var url: URL {
        var query = [String]()
        if let searchQuery = searchQuery {
            query.append("s=\(searchQuery)")
        }
        query.append("apikey=\(apiKey)")
        
        guard let composedUrl = URL(string: "?" + query.joined(separator: "&"), relativeTo: NSURL(string: baseUrlString + path + "?") as URL?) else {
            fatalError("Unable to build request url")
        }
        
        return composedUrl
    }
    
    init(path: String, query: String? = nil) {
        self.path = path
        guard var query = query else {
            self.searchQuery = nil
            return
        }
        
        query = query.replacingOccurrences(of: " ", with: "+")
        self.searchQuery = query
    }
}

class APIService: APIServiceProtocol {
    
    func searchMovies(for name: String, complete: @escaping ( [MovieShort], Error?) -> ()) {
        
        let urlComponents = UrlComponents(path: "", query: name)
        
        AF.request(urlComponents.url).validate()
          .responseDecodable(of: MoviesResponse.self) { response in
              
              // Controlar error en la respuesta
              if let error = response.error {
                  return complete( [], error)
              }
              
              // Controlar que la API devuelva contenido
              guard let result = response.value else { return complete( [], nil) }
            
              guard let list = result.search else {
                  
                  if let error = result.error {
                      // La peticion es correcta pero no hay resultados de la busqueda
                                            
                      return complete( [], NSError(domain: "", code: 401, userInfo: [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Not Found", value: error, comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Not Found", value: error, comment: "")
                        ]))
                  }
                  
                  return complete( [], NSError(domain: "", code: 401, userInfo: [
                    NSLocalizedDescriptionKey :  NSLocalizedString("No Results", value: "No results", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("No Results", value: "No results", comment: "")
                    ]))
              }
              
              //
              complete( list, nil)
        }
        
    }
    

}
