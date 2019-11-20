//
//  HistoryViewModelTest.swift
//  FlicksTests
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import XCTest
@testable import Flicks

class HistoryViewModelTest: XCTestCase {
    
    var sut: HistoryViewModel?
    
    override func setUp() {
        super.setUp()
        sut = HistoryViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testRemoveHistoryCell(){
        
        let sut = self.sut!
        sut.fetchData()
        
        if let history = UserDefaultsManager.getHistory(){
            let initialCount = history.count
            
            if initialCount > 0{
                let indexPath = IndexPath(row: 0, section: 0)
                sut.removeHistoryCell(at: indexPath)
                
                let updatedCount = UserDefaultsManager.getHistory()!.count
                XCTAssertEqual(updatedCount, initialCount - 1)
            }
        }
    }
    
    func testAddHistoryData(){
        let sut = self.sut!
        let queryString = "Hello"
        sut.fetchData()
        
        sut.setData(for: queryString)
        
        let historyArray:[History] = UserDefaultsManager.getHistory()!
        XCTAssert(historyArray.contains(where: { $0.keyword == queryString}))
    }
    
    func testGetCellViewModel(){
        
        let sut = self.sut!
        UserDefaultsManager.deleteUserDefaults()
        sut.setData(for: "Hello")
        sut.fetchData()
        let indexpath = IndexPath(item: 0, section: 0)
        
        XCTAssertEqual(sut.getHistoryCellViewModel(at: indexpath).titleLabel, "Hello")
    }
    
    func testUserPressed(){
        let sut = self.sut!
        UserDefaultsManager.deleteUserDefaults()
        sut.setData(for: "Hello")
        sut.fetchData()
        let indexpath = IndexPath(item: 0, section: 0)
        
        XCTAssertEqual(sut.userPressed(at: indexpath), "Hello")
        
        UserDefaultsManager.deleteUserDefaults()
        
    }
    
    func testFetchHistoryErrorMessages(){
        
        let sut = self.sut!
        UserDefaultsManager.deleteUserDefaults()
        
        sut.fetchData()
        
        XCTAssertEqual(sut.errorTitle, "No Data")
        XCTAssertEqual(sut.errorMessage, "No History Data available")
    }
}
