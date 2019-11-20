//
//  History.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation

class History:NSObject,NSCoding{
    
    var keyword:String
    
    init(keyword:String) {
        self.keyword = keyword
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(keyword, forKey: "keyword")
    }
    
    required init?(coder: NSCoder) {
        self.keyword = coder.decodeObject(forKey: "keyword") as? String ?? ""
    }
    
}
