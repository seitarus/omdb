//
//  OMDBTests.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import XCTest
@testable import OMDB

class OMDBTests: XCTestCase {

    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_search_movie() {
        
        // Given A apiservice
        let sut = self.sut!
        
        // When fetch top stories
        let expect = XCTestExpectation(description: "callback")
        
        let name = "batman"
        let currentPage = 1
        
        sut.searchMovies(for: name, page: currentPage) { (movies, total, error) in
            expect.fulfill()
            for movie in movies {
                XCTAssertNotNil(movie)
            }
        }
        
        wait(for: [expect], timeout: 3.1)
    }

}
