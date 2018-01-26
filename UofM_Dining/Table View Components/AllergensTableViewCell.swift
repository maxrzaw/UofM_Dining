//
//  AllergensTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 11/30/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

/*
 Comments
 * Selection set to None in Main.storybaord
 */
import UIKit

class AllergensTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var list: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
