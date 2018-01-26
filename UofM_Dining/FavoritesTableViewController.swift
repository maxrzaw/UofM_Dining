//
//  FavoritesTableViewController.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/7/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var daySelector: UISegmentedControl!
    let provider = MenusProvider.shared
    @IBOutlet weak var footer: FavoritesViewFooter!
    @IBOutlet weak var RemoveAllButton: UIBarButtonItem!
    
    // MARK: Activity Indicator
    var activityIndicator = UIActivityIndicatorView()
    var refresher: UIRefreshControl!
    
    // MARK: Variables and Constants
    var todaysMenuItems = [MenuItem]()
    var todaysFavs = [MenuItem]()
    var tomorrowsMenuItems = [MenuItem]()
    var tomorrowsFavs = [MenuItem]()
    var todaysNames = [String]()
    var tomorrowsNames = [String]()
    
    let favManager = FavoriteManager.shared
    var selectedDayIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable day selector
        self.daySelector.isEnabled = false
        self.tableView.tableFooterView = footer
        self.showActivityIndicator()
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMenuItems), name: .todayAndTomorrowsMenuItemsHaveLoaded, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadMenuItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only 1 section ever
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of items may change based on day
        if self.selectedDayIndex == 0 {
            if self.todaysFavs.count == 0 && provider.todayAndTomorrowMenuItemsHaveLoaded {
                self.footer.displayNoMeal()
            } else {
                self.footer.hide()
            }
            return self.todaysFavs.count
        } else {
            if self.tomorrowsFavs.count == 0 && provider.todayAndTomorrowMenuItemsHaveLoaded {
                self.footer.displayNoMeal()
            } else {
                self.footer.hide()
            }
            return self.tomorrowsFavs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavoriteTableViewCell
        
        // Configure the cell...
        if daySelector.selectedSegmentIndex == 0 {
            cell.nameLabel.text = self.todaysFavs[indexPath.row].name
            cell.dayLabel.text = self.todaysFavs[indexPath.row].meal
            cell.locationLabel.text = self.todaysFavs[indexPath.row].diningLocationName
            cell.favControl.menuItemName = self.todaysFavs[indexPath.row].name
        } else {
            cell.nameLabel.text = self.tomorrowsFavs[indexPath.row].name
            cell.dayLabel.text = self.tomorrowsFavs[indexPath.row].meal
            cell.locationLabel.text = self.tomorrowsFavs[indexPath.row].diningLocationName
            cell.favControl.menuItemName = self.tomorrowsFavs[indexPath.row].name
        }
        return cell
    }
    
    // MARK: Actions
    @IBAction func RemoveAll(_ sender: UIBarButtonItem) {
        favManager.removeAll()
        self.loadMenuItems()
    }
    
    
    
    @objc func loadMenuItems() {
        if provider.todayAndTomorrowMenuItemsHaveLoaded {
            perform(#selector(self.updateArrays), with: nil, afterDelay: 0.2)
        }
    }
    
    
    
    
    // MARK: Activity indicator
    func showActivityIndicator() {
        tableView.allowsSelection = false
        let label = UILabel()
        label.textColor = UIColor.umMaize
        label.text = "Loading..."
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 5, width: 200, height: 24)
        let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.activityIndicator = UIActivityIndicatorView(frame: frame)
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.activityIndicator.color = UIColor.umMaize
        self.activityIndicator.center = self.view.center
        self.activityIndicator.backgroundColor = UIColor.umBlue
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.layer.masksToBounds = true
        self.activityIndicator.addSubview(label)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.tableView.addSubview(self.activityIndicator)
    }
    
    func hideActivityIndicator() {
        tableView.allowsSelection = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: Refresh
    @objc func refresh() {
        if provider.todayAndTomorrowMenuItemsHaveLoaded {
            self.loadMenuItems()
        }
    }
    
    // MARK: Sorting
    @objc func updateArrays() {
        if provider.todaysMenuItemsHaveLoaded && provider.tomorrowsMenuItemsHaveLoaded {
            self.todaysFavs.removeAll()
            self.tomorrowsFavs.removeAll()
            self.todaysNames.removeAll()
            self.tomorrowsNames.removeAll()
            todaysFavs = provider.todaysMenuItems.filter({(menuItem) -> Bool in
                if favManager.favArray.contains(menuItem.name) && !self.todaysNames.contains(menuItem.name) {
                    self.todaysNames.append(menuItem.name)
                    return true
                } else {
                    return false
                }
            })
            tomorrowsFavs = provider.tomorrowsMenuItems.filter({(menuItem) -> Bool in
                if favManager.favArray.contains(menuItem.name) && !self.tomorrowsNames.contains(menuItem.name) {
                    self.tomorrowsNames.append(menuItem.name)
                    return true
                } else {
                    return false
                }
            })
            self.refresher.endRefreshing()
            self.hideActivityIndicator()
            self.daySelector.isEnabled = true
            self.tableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func daySelectorChanged(_ sender: UISegmentedControl) {
        //switch to correct day, today is index 0, tomorrow is index 1
        self.selectedDayIndex = self.daySelector.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "nutritionFromFav" {
            if let nutritionValueTVC = segue.destination as? NutritionValueTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if daySelector.selectedSegmentIndex == 0 {
                        nutritionValueTVC.myMenuItem = todaysFavs[indexPath.row]
                    } else {
                        nutritionValueTVC.myMenuItem = self.tomorrowsFavs[indexPath.row]
                    }
                }
            }
        }
    }
    
    
}
