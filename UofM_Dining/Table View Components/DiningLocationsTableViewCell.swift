//
//  DiningLocationsTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 11/21/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class DiningLocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var diningLocationName: UILabel!
    @IBOutlet weak var openNow: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
