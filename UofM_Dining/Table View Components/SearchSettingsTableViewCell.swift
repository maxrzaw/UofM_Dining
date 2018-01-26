//
//  SearchSettingsTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/4/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

/*
 Cell delegate inspiration from: https://stackoverflow.com/questions/47478257/swift-how-to-detect-an-action-button-in-uitableviewcell-is-pressed-from-viewco
*/
protocol SearchSettingsTableViewCellDelegate: class {
    func didTap(_ cell: SearchSettingsTableViewCell)
}

class SearchSettingsTableViewCell: UITableViewCell {

    weak var delegate: SearchSettingsTableViewCellDelegate?
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.didTap(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
