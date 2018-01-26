//
//  AdditionalOptionsTableViewController.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/2/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class AdditionalOptionsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // Mark: Properties
    let searchOptions = SearchOptions.shared
    
    /// Either dining locations or allergens
    var selection: String!
    
    // Allergens
    var allergenNames: [String]!
    var selectedAllergens: [String] = []
    
    // Dining Locations
    var diningLocationNames: [String]!
    var selectedDiningLocationsNames: [String]!
    
    var shouldSaySelectAll = false
    
    override func viewWillAppear(_ animated: Bool) {
        diningLocationNames = searchOptions.diningLocationNameList
        selectedDiningLocationsNames = searchOptions.tempDiningLocationSettings
        allergenNames = searchOptions.allergenList
        selectedAllergens = searchOptions.tempAllergenSettings
        
        // If no dining locations selected, button will say "Select All"
        if selectedDiningLocationsNames.count == 0 {
            shouldSaySelectAll = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchOptions.tempDiningLocationSettings = selectedDiningLocationsNames
        searchOptions.tempAllergenSettings = selectedAllergens
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if selection == "Allergens" {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selection == "Allergens" {
            return "Do not show menu items with selected allergens"
        } else {
            if section == 1 {
                return "Only show menu items in selected dining locations"
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selection == "Allergens" {
            return allergenNames.count
        } else {
            if section == 0 {
                return 1
            } else {
                return diningLocationNames.count
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempID", for: indexPath)
        cell.tintColor = UIColor.umMaize
        if selection == "Dining Locations" {
            if indexPath.section == 0 {
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.umMaize
                if allDLSelected() {
                    cell.textLabel?.text = "Deselect All"
                } else {
                    cell.textLabel?.text = "Select All"
                }
            } else {
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.text = diningLocationNames[indexPath.row]
                if selectedDiningLocationsNames.contains(diningLocationNames[indexPath.row]) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        } else {
            if selectedAllergens.contains(allergenNames[indexPath.row]) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.textLabel!.text = allergenNames[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if selection == "Dining Locations" {
            
            if indexPath.section == 0 {
                if allDLSelected() {
                    shouldSaySelectAll = false
                    selectedDiningLocationsNames = []
                    self.tableView.reloadData()
                } else {
                    shouldSaySelectAll = true
                    selectedDiningLocationsNames = diningLocationNames
                    self.tableView.reloadData()
                }
            } else {
                let diningLocationName = diningLocationNames[indexPath.row]
                if selectedDiningLocationsNames.contains(diningLocationName) {
                    selectedDiningLocationsNames.remove(at: selectedDiningLocationsNames.index(of: diningLocationName)!)
                    cell.accessoryType = .none
                } else {
                    selectedDiningLocationsNames.append(diningLocationName)
                    cell.accessoryType = .checkmark
                }
            }
            
            
        } else {
            let cellAllergen = allergenNames[indexPath.row]
            if selectedAllergens.contains(cellAllergen) {
                selectedAllergens.remove(at: selectedAllergens.index(of: cellAllergen)!)
                cell.accessoryType = .none
            } else {
                selectedAllergens.append(cellAllergen)
                cell.accessoryType = .checkmark
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func allDLSelected() -> Bool {
        return selectedDiningLocationsNames.count == diningLocationNames.count
    }
    
}


