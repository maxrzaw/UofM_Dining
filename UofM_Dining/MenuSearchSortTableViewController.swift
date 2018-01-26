//
//  MenuSearchSortTableViewController.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/2/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

/*
 Inspiration from https://blog.apoorvmote.com/how-to-pop-up-datepicker-inside-static-cells/
 */


import UIKit

class MenuSearchSortTableViewController: UITableViewController, SearchSettingsTableViewCellDelegate {
    
    private let toAdditionalOptionsTableViewControllerSegueID = "toAdditionalOptionsTableViewControllerSegueID"
    private let dateShowerCellID = "dateShowerCellID"
    private let datePickerCellID = "datePickerCellID"
    private let menuSearchSortTableViewCellID = "menuSearchSortTableViewCellID"
    private let searchSettingsTableViewCellID = "searchSettingsTableViewCellID"
    
    let searchOptions = SearchOptions.shared
    
    var dateFormatter = DateFormatter()
    var datePickerHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Options"
        setDateFormatter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDateFormatter() {
        dateFormatter.dateStyle = .short
    }
    
    func toggleDatepicker() {
        datePickerHidden = !datePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: dateShowerCellID, for: indexPath) as! DateShowerTableViewCell
                cell.dateLabel.text = dateFormatter.string(from: searchOptions.selectedDate)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellID, for: indexPath) as! DatePickerTableViewCell
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                let lowerBoundDate = formatter.date(from: "2016/11/21 9:31")
                let upperBoundDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
                cell.datePicker.minimumDate = lowerBoundDate
                cell.datePicker.maximumDate = upperBoundDate
                cell.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                
                return cell
                
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuSearchSortTableViewCellID, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell.textLabel?.text = "Dining Locations"
            } else {
                cell.textLabel?.text = "Allergens"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: searchSettingsTableViewCellID, for: indexPath) as! SearchSettingsTableViewCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.settingsButton.setTitle("Set dining locations and allergens settings as default", for: .normal)
            } else {
                cell.settingsButton.setTitle("Reset settings", for: .normal)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0  && indexPath.row == 0 {
            toggleDatepicker()
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: toAdditionalOptionsTableViewControllerSegueID, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTap(_ cell: SearchSettingsTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        if indexPath?.row == 0 {
            searchOptions.saveSettingsAsDefault()
            
        } else if indexPath?.row == 1 {
            searchOptions.resetSettings()
        }
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        searchOptions.selectedDate = sender.date
        let dateShowerCellIndexPath = IndexPath(row: 0, section: 0)
        let dateShowerCell = tableView.cellForRow(at: dateShowerCellIndexPath)! as! DateShowerTableViewCell
        dateShowerCell.dateLabel.text = dateFormatter.string(from: searchOptions.selectedDate)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Sets selection (either dining locations or allergens) to additional options page
        if segue.identifier == toAdditionalOptionsTableViewControllerSegueID {
            if let additionalOptionsTVC = segue.destination as? AdditionalOptionsTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if indexPath.row == 0 {
                        additionalOptionsTVC.selection = "Dining Locations"
                    } else if indexPath.row == 1 {
                        additionalOptionsTVC.selection = "Allergens"
                    }
                }
            }
            
        }
        
    }
}
