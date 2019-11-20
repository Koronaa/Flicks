//
//  FlickerResponseViewModel.swift
//  Flicks
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
class FlickerResponseViewModel{
    
    var updateLoadingClosure:(()->())?
    var reloadCollectionViewClosure:(()->())?
    var showErrorMessageClosure:(()->())?
    
    let flickerService:APIServiceProtocol
    private var photos:[Photo] = []
    private var flickerResponse:FlickerResponse?
    
    init(flickerService:APIServiceProtocol = FlickerSearchService()) {
        self.flickerService = flickerService
    }
    
    private var cellViewModels:[PhotoCellViewModel] = []{
        didSet{
            self.reloadCollectionViewClosure?()
        }
    }
    
    var isLoading:Bool = false{
        didSet{
            self.updateLoadingClosure?()
        }
    }
    
    var errorMessage:String?{
        didSet{
            self.showErrorMessageClosure?()
        }
    }
    
    var numberOfCells:Int{
        return cellViewModels.count
    }
    
    func fetchData(for query:String,pageNo:Int,itemsPerPage:Int){
        if pageNo == 1{
            isLoading = true
            self.photos.removeAll()
            self.cellViewModels.removeAll()
        }
        flickerService.fetchImages(for: query, pageNo: pageNo, itemsPerPage: itemsPerPage) { (flickerResponse, errorString) in
            if let error = errorString{
                self.errorMessage = error
                return
            }else{
                self.flickerResponse = flickerResponse
                if self.photos.count > 0{
                    self.photos.append(contentsOf: flickerResponse?.photos ?? [])
                }else{
                    self.photos = flickerResponse?.photos ?? []
                }
                
                if self.cellViewModels.count > 0{
                    let addedPhotos:[Photo] = flickerResponse?.photos ?? []
                    let addedCellViewModels:[PhotoCellViewModel] = self.createCellViewModel(from: addedPhotos)
                    self.cellViewModels.append(contentsOf: addedCellViewModels)
                }else{
                    self.cellViewModels = self.createCellViewModel(from: self.photos)
                }
                self.isLoading = false
            }
        }
    }
    
    func createCellViewModel(from photos:[Photo]) -> [PhotoCellViewModel]{
        return photos.map({return PhotoCellViewModel(imageURL: $0.imageURL)})
    }
    
    
    func getCellViewModel(at indexPath:IndexPath) -> PhotoCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
    func getTotalPages() -> Int{
        return flickerResponse!.totlePages
    }
    
    func getCurrentPage() -> Int{
        return flickerResponse!.currentPage
    }
}
