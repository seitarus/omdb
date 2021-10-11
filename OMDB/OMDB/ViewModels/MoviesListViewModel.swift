//
//  MoviesListViewModel.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class MoviesListViewModel {
    
    private weak var delegate: MoviesListViewModelDelegate?
    
    let apiService: APIServiceProtocol
    
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var queryTerm: String = ""
    
    private var movies: [MovieShort] = []
    
    init( apiService: APIServiceProtocol = APIService(), delegate: MoviesListViewModelDelegate ) {
        self.apiService = apiService
        self.delegate = delegate
    }
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
      return movies.count
    }
    
    func getMovie(at index: Int) -> MovieShort {
      return movies[index]
    }

    
    var selectedMovieImdbID: String?
    
    func searchMovies(for name: String) {
        
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        
        if name != queryTerm {
            
            queryTerm = name
            self.currentPage = 1
            
            self.total = 0
            self.movies.removeAll()
        }
        
        print ( "Current page: \(currentPage)" )
        
        apiService.searchMovies(for: name, page: currentPage) { [weak self] movies, total, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    
                    self?.isFetchInProgress = false
                                    
                    self?.delegate?.onFetchFailed(with: error.localizedDescription)
                }
                    
    //            print(movies);
                self?.isFetchInProgress = false
                
                self?.total = total
                
                self?.movies.append(contentsOf: movies)
                
                if let page = self?.currentPage, page > 1 {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: movies)
                    self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self?.delegate?.onFetchCompleted(with: .none)
                }
                
                self?.currentPage += 1
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newMovies: [MovieShort]) -> [IndexPath] {
      let startIndex = movies.count - newMovies.count
      let endIndex = startIndex + newMovies.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

extension MoviesListViewModel {
    
    func userPressed( at indexPath: IndexPath ){
        
        let movie = self.movies[indexPath.row]
        
        self.selectedMovieImdbID = movie.imdbID
    }
}
