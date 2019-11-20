//
//  Photo.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation

struct Photo {
    var title:String
    var id:String
    var secret:String
    var farm:Int
    var server:String
    
    var imageURL:URL{
        return URL(string: String(format: URLConstants.Api.Path.imageURL, farm.description,server,id,secret))!
    }
}
