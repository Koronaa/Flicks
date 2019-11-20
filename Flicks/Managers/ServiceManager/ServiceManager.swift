//
//  ServiceManager.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


typealias onAPIResponse = (_ response:Any?, _ statusCode:Int)->()

class ServiceManager{
    
    static func APIRequest(url:URL,method:HTTPMethod,params:Parameters? = nil,headers:HTTPHeaders? = nil,encoding:ParameterEncoding? = JSONEncoding.default,onResponse:onAPIResponse?){
        if ReachabilityManager.isConnectedToNetwork(){
            Alamofire.request(url, method: method, parameters: params, encoding: encoding!, headers: headers).responseJSON { response in
                if let statusCode = response.response?.statusCode{
                    if statusCode >= 200 && statusCode < 500{
                        onResponse?(response,statusCode)
                    }else if statusCode == 500{
                        UIHelper.hideHUD()
                        UIHelper.showErrorMessage(message: "Service Down! Try Again Later...")
                        onResponse?(response,statusCode)
                    }
                }else{
                    UIHelper.hideHUD()
                    UIHelper.makeNoServiceAlert()
                }
            }
        }else{
            UIHelper.hideHUD()
            UIHelper.makeNoInternetAlert()
        }
    }
}
