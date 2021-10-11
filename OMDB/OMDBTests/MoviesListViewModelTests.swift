//
//  MoviesListViewModelTests.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import XCTest
@testable import OMDB

class MoviesListViewModelTests: XCTestCase {
    var sut: MoviesListViewModel!
    var mockAPIService: MockApiService!
    let termSearch = "batman"
    let termSearchFail = "aaaa"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        mockAPIService = MockApiService()
        
        sut = MoviesListViewModel(apiService: mockAPIService)
        
    }



    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }


    func test_seach_movies() {
        // Given
        mockAPIService.completeMovies = [MovieShort]()

        // When
        sut.searchMovies(for: termSearch)
        
        // Assert
        XCTAssert(mockAPIService!.isSearchMoviesCalled)

    }

    func test_search_movies_fail() {

//        //Create an instance of Api error for mocking the fetch fail
//        let error

        // When
        sut.searchMovies(for: termSearchFail)

        //Replace the nil with error instace
        mockAPIService.searchMoviesFail(error: nil )

        // Sut should display predefined error message
        XCTAssertEqual( sut.isFetchInProgress, false)

    }


    func test_get_movie_view_model() {

        //Given a sut with fetched topstories
        goToSearchMoviesFinished()

        let indexPath = IndexPath(row: 1, section: 0)
        let testMovie = mockAPIService.completeMovies[indexPath.row]

        // When
        let vm = sut.getMovie(at: indexPath.row)

        //Assert
        XCTAssertEqual( vm.title, testMovie.title)
        XCTAssertEqual( vm.year, testMovie.year)

    }
    
}


//MARK: State control
extension MoviesListViewModelTests {
    private func goToSearchMoviesFinished() {
        mockAPIService.completeMovies = StubGenerator().stubMovies()
        sut.searchMovies(for: termSearch)
        mockAPIService.searchMoviesSuccess()
    }
}


class MockApiService: APIServiceProtocol {
    
    var completeMovies: [MovieShort] = [MovieShort]()
    var completeMoviesClosure: (( [MovieShort], Int, Error?) -> ())!
    var completeMovieClosure: (( Movie, Error?) -> ())!
    
    var isSearchMoviesCalled = false
    var isFetchMovieCalled = false
    
    func searchMovies(for name: String, page: Int, complete: @escaping ([MovieShort], Int, Error?) -> ()) {
        isSearchMoviesCalled = true
        completeMoviesClosure = complete
    }
    
    func fetchMovie(by imdbId: String, complete: @escaping (Movie?, Error?) -> ()) {
        isFetchMovieCalled = true
        completeMovieClosure = complete
    }
    
    func searchMoviesSuccess() {
        completeMoviesClosure(  completeMovies, 463, nil )
    }
    
    func searchMoviesFail(error: Error?) {
        completeMoviesClosure( completeMovies, 0, error )
    }
    
}

class StubGenerator {
    func stubMovies() -> [MovieShort] {
        
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let moviesList = try! decoder.decode(MoviesResponse.self, from: data)
        return moviesList.search!
    }
}
