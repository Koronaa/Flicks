//
//  SearchService.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum SearchRouter{
    case search(Int,Int,String)
    
    
    var url:URL{
        switch self {
        case .search(let pageNo, let itemsPerPage, let queryString):
            return URL(string: String(format: URLConstants.Api.Path.search, pageNo.description,itemsPerPage.description,queryString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        }
    }
    
    var method:HTTPMethod{
        switch self {
        case .search(_, _, _):
            return .get
        }
    }
}

class SearchService{
    
    func searchImages(for queryString:String, itemsPerPage:Int, pageNo:Int,onResponse:onAPIResponse?){
        ServiceManager.APIRequest(url: SearchRouter.search(pageNo, itemsPerPage, queryString).url, method: SearchRouter.search(pageNo, itemsPerPage, queryString).method) { (response, code) in
            let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
            onResponse?(jsonData,code)
        }
    }
}
