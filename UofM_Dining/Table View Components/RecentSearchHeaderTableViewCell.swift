//
//  RecentSearchHeaderTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/1/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class RecentSearchHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
