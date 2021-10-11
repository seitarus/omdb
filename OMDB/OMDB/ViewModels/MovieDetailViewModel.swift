//
//  MoviesListViewModel.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class MovieDetailViewModel {
    
    let apiService: APIServiceProtocol
    
    private var movieDetail: Movie? {
        didSet {
            self.reloadViewClosure?()
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
    
    var reloadViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
        
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchMovie(by imdbId: String) {
        self.isLoading = true
        
        apiService.fetchMovie(by: imdbId) { [weak self] movie, error in
            
            self?.isLoading = false
            
            if let error = error {
                self?.alertMessage = error.localizedDescription
            }
                
//            print(movie);
            self?.movieDetail = movie
            
        }
    }
    
    func getMovie() -> Movie? {
        
        return movieDetail
    }
    
    func downloadImage( complete: @escaping ( _ imageUrl: URL )->() ) {
        
        self.isLoading = true
        
        guard let poster = movieDetail?.poster, let url = URL(string: poster ) else { return }
        let urlRequest = URLRequest(url: url)
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent( (poster as NSString).lastPathComponent )
            let fileURL = documentsURL.appendingPathComponent( "image.jpeg" )

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(urlRequest, to: destination).response { [weak self] response in

            self?.isLoading = false
            
            if response.error == nil, let imagePath = response.fileURL {
                
                complete( imagePath )
            }
        }

    }
}
