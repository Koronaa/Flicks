//
//  PhotoCollectionViewCell.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    
    var photoCellViewModel:PhotoCellViewModel?{
        didSet{
            imageView.sd_setImage(with: photoCellViewModel?.imageURL, completed: nil)
        }
    }
    
    func setupCell(imageWidth:CGFloat){
        imageViewWidthConstraint.constant = imageWidth
        UIHelper.addCornerRadius(to: shadowView)
        UIHelper.addShadow(to: shadowView)
    }
}
