//
//  UIHelper.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import NotificationBannerSwift

class UIHelper{
    
    static func addShadow(to view:UIView){
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1.0, height: -1.0)
        view.layer.shadowOpacity = 0.4
    }
    
    static func addCornerRadius(to view:UIView,withRadius radius:CGFloat = 4){
        view.layer.cornerRadius = radius
    }
    
    static func showHUD(){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
        }
    }
    
    static func hideHUD(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func show(view:UIView){
        view.isHidden = false
    }
    
    static func hide(view:UIView){
        view.isHidden = true
    }
    
    static func showErrorMessage(title:String = "Error!", message:String){
        let banner = NotificationBanner(title: title, subtitle: message, style: .danger)
        banner.show()
    }
    
    static func makeNoInternetAlert(){
        showErrorMessage(message: "No Internet.")
    }
    
    static func makeNoServiceAlert(){
        showErrorMessage(message: "No Services Available.")
    }
}

