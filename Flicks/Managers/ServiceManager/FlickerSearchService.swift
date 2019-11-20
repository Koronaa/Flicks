//
//  FlickerSearchService.swift
//  Flicks
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol APIServiceProtocol {
    func fetchImages(for query:String,pageNo:Int,itemsPerPage:Int,onComplete: @escaping(_ flickerResponse:FlickerResponse?,_ error:String?) -> Void)
}


class FlickerSearchService:APIServiceProtocol{
    
    func fetchImages(for query:String,pageNo:Int,itemsPerPage:Int,onComplete: @escaping(_ flickerResponse:FlickerResponse?,_ error:String?) -> Void){
        var tempPhotosArray:[Photo] = []
        let searchService = SearchService()
        searchService.searchImages(for: query, itemsPerPage: itemsPerPage, pageNo: pageNo) { (response, responseCode) in
            UIHelper.hideHUD()
            if responseCode == 200{
                if let jsonResponse = response as? JSON{
                    if let photosJSON = jsonResponse["photos"].dictionary{
                        if let currentPage = photosJSON["page"]?.int{
                            if let totalPages = photosJSON["pages"]?.int{
                                if let photos = photosJSON["photo"]?.array{
                                    for photo in photos{
                                        if let id = photo["id"].string,
                                            let title = photo["title"].string,
                                            let secret = photo["secret"].string,
                                            let farm = photo["farm"].int,
                                            let server = photo["server"].string
                                        {
                                            let photo = Photo(title: title, id: id, secret: secret, farm: farm, server: server)
                                            tempPhotosArray.append(photo)
                                        }
                                    }
                                    let flickerResponse = FlickerResponse(currentPage: currentPage, totlePages: totalPages, photos: tempPhotosArray)
                                    if tempPhotosArray.count == 0{
                                        onComplete(nil,"Couldn't find any results for \(query)")
                                    }else{
                                        onComplete(flickerResponse,nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                onComplete(nil,"Somethig went wrong while retreiving data. Please try again.")
            }
        }
        
    }
}
