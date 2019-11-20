//
//  HistoryTableViewCell.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var queryLabel: UILabel!
    
    var historyCellViewModel:HistoryCellViewModel?{
        didSet{
            queryLabel.text = historyCellViewModel!.titleLabel
        }
    }
}
