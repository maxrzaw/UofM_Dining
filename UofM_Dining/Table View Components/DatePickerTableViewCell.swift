//
//  DatePickerTableViewCell.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/4/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
