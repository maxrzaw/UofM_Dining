//
//  FavoriteTableViewCell.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/8/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var favControl: FavoritesControl!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
