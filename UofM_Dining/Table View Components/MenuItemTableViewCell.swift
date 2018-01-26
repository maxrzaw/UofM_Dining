//
//  MenuItemTableViewCell.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 11/21/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

/*
 Comments
 * in Main.storyboard, priceLabel is set to hidden
 
 */
class MenuItemTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    //favoriteControl
    @IBOutlet var favoriteControl: FavoritesControl!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
