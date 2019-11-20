//
//  PerformanceTest.swift
//  FlicksTests
//
//  Created by Sajith Konara on 11/4/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import XCTest
@testable import Flicks

class UserDefaultsPerformanceTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        UserDefaultsManager.deleteUserDefaults()
        super.tearDown()
    }

    func testPerformanceUserDefaultsRead() {
        self.measure {
            let _ = UserDefaultsManager.getHistory()
        }
    }
    
    func testPerformanceUserDefaultsWrite(){
        self.measure {
            if let history = UserDefaultsManager.getHistory(){
                var tempHistory = history
                tempHistory.append(History(keyword: "Test"))
                UserDefaultsManager.setHistory(for: tempHistory)
            }
        }
    }
}
