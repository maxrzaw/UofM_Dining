//
//  NutritionFactTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 11/30/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class NutritionFactTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nutritionFactNameLabel: UILabel!
    @IBOutlet weak var nutritionValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
