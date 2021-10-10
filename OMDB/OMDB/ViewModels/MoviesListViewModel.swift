//
//  MoviesListViewModel.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

class MoviesListViewModel {
    
    let apiService: APIServiceProtocol
    
    private var movies: [MovieShort] = [MovieShort]()
    
    private var cellViewModels: [MovieListCellViewModel] = [MovieListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func searchMovies(for name: String) {
        self.isLoading = true
        
        apiService.searchMovies(for: name) { [weak self] movies, error in
            
            self?.isLoading = false
            
            if let error = error {
                self?.alertMessage = error.localizedDescription
            }
                
//            print(movies);
                
            self?.processFetchedMovies(movies: movies)
        }
    }
    
    func createCellViewModel( movie: MovieShort ) -> MovieListCellViewModel {
                
        return MovieListCellViewModel(titleText: movie.title, yearText: movie.year, imageUrl: movie.poster)
    }
    
    private func processFetchedMovies( movies: [MovieShort] ) {
        self.movies = movies // Cache
        var vms = [MovieListCellViewModel]()
        for movie in movies {
            vms.append( createCellViewModel(movie: movie) )
        }
        self.cellViewModels = vms
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieListCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

struct MovieListCellViewModel {
    let titleText: String
    let yearText: String
    let imageUrl: String
}

struct MovieDetailViewModel {
    let titleText: String
    let directorText: String
    let imageUrl: String
    let detailsText :String
}
