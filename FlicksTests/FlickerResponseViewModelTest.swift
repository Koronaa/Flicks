//
//  PhotoTest.swift
//  FlicksTests
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import XCTest
@testable import Flicks

class FlickerResponseViewModelTest: XCTestCase {
    
    var sut:FlickerResponseViewModel?
    var mockAPIService:MockApiService?
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = FlickerResponseViewModel(flickerService: mockAPIService!)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchFlickerResponse(){
        let sut = self.sut!
        mockAPIService!.flickerResponse = FlickerResponse(currentPage: 1, totlePages: 10, photos: [Photo]())
        sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
        XCTAssert(mockAPIService!.isFetchImagesInvoked)
    }
    
    func testFetchFlickerResponseFail(){
        let sut = self.sut!
        let errorString = "Error"
        sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
        mockAPIService!.fetchFail(error: "Error")
        XCTAssertEqual(sut.errorMessage, errorString)
    }
    
    func testCreateCellViewModel(){
        
        let sut = self.sut!
        let mockAPIService = self.mockAPIService!
        StubGenerator().stubFlickerResponse { (flickerResponse) in
            mockAPIService.flickerResponse = flickerResponse
            
            let expect = XCTestExpectation(description: "Reload Closure Triggered")
            sut.reloadCollectionViewClosure = {() in
                expect.fulfill()
            }
            
            sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
            mockAPIService.fetchSuccess()
            
            XCTAssertEqual(sut.numberOfCells, flickerResponse.photos.count)
            
            self.wait(for: [expect], timeout: 2.0)
        }
        
        
    }
    
    func testLoadingWhenFetching(){
        
        let sut = self.sut!
        let mockAPIService = self.mockAPIService!
        
        var loadingStatus = false
        let expext = XCTestExpectation(description: "Loading Status Updated")
        sut.updateLoadingClosure = {[weak sut] in
            loadingStatus = sut!.isLoading
            expext.fulfill()
        }
        
        sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
        
        XCTAssertTrue(loadingStatus)
        
        mockAPIService.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expext], timeout: 1.0)
    }
    
    
    func testGetCellViewModel(){
        
        let sut = self.sut!
        let mockAPIService = self.mockAPIService!
        StubGenerator().stubFlickerResponse { (flickerResponse) in
            mockAPIService.flickerResponse = flickerResponse
            sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
            mockAPIService.fetchSuccess()
            
            let indexPath = IndexPath(row: 1, section: 0)
            let testPhoto = mockAPIService.flickerResponse.photos[indexPath.row]
            
            let viewModel = sut.getCellViewModel(at: indexPath)
            
            XCTAssertEqual(viewModel.imageURL, testPhoto.imageURL)
        }
    }
    
    func testCellViewModel(){
        
        let sut = self.sut!
        
        let photo:Photo = Photo(title: "Test", id: "123", secret: "131edsf", farm: 1, server: "24235325")
        var photos:[Photo] = []
        photos.append(photo)
        
        let cellViewModel = sut.createCellViewModel(from: photos)
        
        XCTAssertEqual(photo.imageURL, cellViewModel.first!.imageURL)
    }
    
    func testGetCurrentPage(){
        
        let sut = self.sut!
        let mockAPIService = self.mockAPIService!
        let currentPage:Int = 1
        
        sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
        mockAPIService.fetchSuccess()
        
        
        XCTAssertEqual(sut.getCurrentPage(), currentPage)
    }
    
    func testGetTotalNumberOfPages(){
        let sut = self.sut!
        let mockAPIService = self.mockAPIService!
        let totalPages:Int = 10
        
        sut.fetchData(for: "", pageNo: 1, itemsPerPage: 10)
        mockAPIService.fetchSuccess()
        
        XCTAssertEqual(sut.getTotalPages(), totalPages)
    }
}

class MockApiService:APIServiceProtocol {
    
    var isFetchImagesInvoked:Bool = false
    var flickerResponse:FlickerResponse = FlickerResponse(currentPage: 1, totlePages: 10, photos: [Photo]())
    var completeClosure: ((FlickerResponse?, String?) -> Void)!
    
    func fetchImages(for query:String,pageNo:Int,itemsPerPage:Int,onComplete: @escaping(_ flickerResponse:FlickerResponse?,_ error:String?) -> Void){
        isFetchImagesInvoked = true
        completeClosure = onComplete
    }
    
    func fetchSuccess(){
        completeClosure(flickerResponse,nil)
    }
    
    func fetchFail(error:String){
        completeClosure(nil,error)
    }
    
}

class StubGenerator{
    
    func stubFlickerResponse(oncomplete: @escaping(_ flickerResponse:FlickerResponse)->Void){
        let flickerService = FlickerSearchService()
        flickerService.fetchImages(for: "Kittens", pageNo: 1, itemsPerPage: 10) { (retrievedFlickerResponse, errorString) in
            if let response = retrievedFlickerResponse{
                oncomplete(response)
            }
        }
    }
}
