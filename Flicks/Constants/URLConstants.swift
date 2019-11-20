//
//  URLConstants.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation

struct URLConstants{
    
    struct Api {
        
        static let HOST = "https://api.flickr.com"
        static let API_KEY = "fbfa822aa1c59550a02a0f1af1881be3"
        
        struct Path {
            
            static var search:String{
                //page,per_page & text
                return HOST + "/services/rest/?method=flickr.photos.search&api_key=" + API_KEY + "&format=json&nojsoncallback=1&page=%@&per_page=%@&text=%@"
            }
            
            static var imageURL:String{
                return "http://farm%@.static.flickr.com/%@/%@_%@.jpg"
            }
        }
    }
}

