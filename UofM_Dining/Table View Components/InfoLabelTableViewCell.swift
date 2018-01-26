//
//  InfoLabelTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 11/30/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class InfoLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
