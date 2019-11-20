//
//  WebServicePerformanceTest.swift
//  FlicksTests
//
//  Created by Sajith Konara on 11/4/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import XCTest
@testable import Flicks

class WebServicePerformanceTest: XCTestCase {
    
    var sut:FlickerSearchService?
    override func setUp() {
        super.setUp()
        sut = FlickerSearchService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testPerformanceFlickerSearch() {
        let sut = self.sut!
        self.measure {
            let exp = expectation(description: "Server Fetch")
            sut.fetchImages(for: "Kittens", pageNo: 1, itemsPerPage: 3) { (response, error) in
                exp.fulfill()
            }
            waitForExpectations(timeout: 10.0) { (error) in
                print(error?.localizedDescription)
            }
        }
    }
}
