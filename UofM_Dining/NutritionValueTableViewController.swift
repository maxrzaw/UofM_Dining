//
//  NutritionValueTableViewController.swift
//  UofM_Dining
//
//  Created by Divya Ramanathan on 11/29/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

/* Comments
 -Fonts set in Main.storyboard
 */


class NutritionValueTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var nutritionFactsLabel: UILabel!
    @IBOutlet weak var favoritesControl: FavoritesControl!
    
    
    var myMenuItem: MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = myMenuItem.name
        self.favoritesControl.menuItemName = myMenuItem.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // "Nutritional Information"
        
        // Allergens and Such
        if section == 1 {
            return 3
            // Serving Size
        } else if section == 2 {
            // If serving size is not provided, serving size will not show up
            if myMenuItem.servingSize == nil {
                return 0
            } else {
                return 1
            }
            
            // Nutritional Info
        } else if section == 3 {
            return myMenuItem.nutritionInfoArray.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "Nutritional Information"
        
        
        // Allergens and Such
        if indexPath.section == 1 {
            // Allergens
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allergenTableViewCellID", for: indexPath) as! AllergensTableViewCell
                cell.title.text = "Allergens"
                
                if myMenuItem.allergens.count < 1 {
                    cell.list.text = "none"
                } else {
                    cell.list.text = myMenuItem.allergens.joined(separator: ", ")
                }
                
                return cell
                
                // Traits
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allergenTableViewCellID", for: indexPath) as! AllergensTableViewCell
                cell.title.text = "Traits"
                
                if myMenuItem.traits.count < 1 {
                    cell.list.text = "None"
                } else {
                    var stringTraits = [String]()
                    for trait in myMenuItem.traits {
                        stringTraits.append(trait.rawValue)
                    }
                    cell.list.text = stringTraits.joined(separator: ", ")
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allergenTableViewCellID", for: indexPath) as! AllergensTableViewCell
                cell.title.text = "Information"
                
                if myMenuItem.infoLabel == nil {
                    cell.list.text = "None"
                } else {
                    cell.list.text = myMenuItem.infoLabel
                }
                return cell
                
            }
            // Serving Size
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "servingTableViewCellID", for: indexPath) as! ServingTableViewCell
            if let servingSize = myMenuItem.servingSize {
                cell.label.text = "Serving Size " + servingSize
            }
            if let servingSizeGrams = myMenuItem.servingSizeInGrams {
                cell.label.text!.append(" (" + String(servingSizeGrams) + "g)")
            }
            
            return cell
            
            // Nutritional Info
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionFactTableViewCellID", for: indexPath) as! NutritionFactTableViewCell
            cell.nutritionFactNameLabel.text = myMenuItem.nutritionInfoArray[indexPath.row].name
            cell.nutritionValueLabel.text = myMenuItem.nutritionInfoArray[indexPath.row].value
            return cell
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

