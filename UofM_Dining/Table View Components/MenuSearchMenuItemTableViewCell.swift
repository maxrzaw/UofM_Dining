//
//  MenuSearchMenuItemTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/1/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class MenuSearchMenuItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var diningLocationNameLabel: UILabel!
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
