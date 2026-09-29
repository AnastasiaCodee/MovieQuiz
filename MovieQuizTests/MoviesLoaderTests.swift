//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Анастасия on 22.09.2026.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            
            switch result {
            case .success(let movies):
                
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }

func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected success")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
