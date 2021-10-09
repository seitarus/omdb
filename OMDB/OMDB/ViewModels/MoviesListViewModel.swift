//
//  MoviesListViewModel.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

class MoviesListViewModel {
    
    private var movies: [Movie] = [Movie]()
    
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
    
    func initFetch() {
//        self.isLoading = true
        
        //TODO: Call API
        
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieListCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

struct MovieListCellViewModel {
    let titleText: String
    let directorText: String
    let imageUrl: String
}

struct MovieDetailViewModel {
    let titleText: String
    let directorText: String
    let imageUrl: String
    let detailsText :String
}
