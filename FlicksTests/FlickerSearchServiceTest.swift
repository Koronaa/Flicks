//
//  FlickerSearchServiceTest.swift
//  FlicksTests
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import XCTest
@testable import Flicks

class FlickerSearchServiceTest: XCTestCase {
    
    var sut:FlickerSearchService?
    
    override func setUp() {
        super.setUp()
        sut = FlickerSearchService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchPhotosForGivenString(){
        
        let sut = self.sut!
        
        let expect = XCTestExpectation(description: "Callback")
        
        sut.fetchImages(for: "Kittens", pageNo: 1, itemsPerPage: 10) { (flickerResponse, errorString) in
            expect.fulfill()
            XCTAssertNotNil(flickerResponse)
            if let response = flickerResponse{
                XCTAssertEqual(response.photos.count, 10)
                XCTAssertEqual(response.currentPage, 1)
                for photo in response.photos{
                    XCTAssertNotNil(photo)
                }
            }
            
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    
    func testFeatchPhotosForNoResults(){
        let sut = self.sut!
        
        let expect = XCTestExpectation(description: "Callback")
        
        sut.fetchImages(for: "Rohan Rangalal", pageNo: 1, itemsPerPage: 10) { (flickerResponse, errorString) in
            expect.fulfill()
            XCTAssertNil(flickerResponse)
            XCTAssertNotNil(errorString)
            XCTAssertEqual(errorString, "Couldn't find any results for Rohan Rangalal")
        }
        wait(for: [expect], timeout: 100.0)
    }
    
}
