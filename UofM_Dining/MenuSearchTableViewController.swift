//
//  MenuSearchTableViewController.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/1/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit
import Foundation

/*
 Inspiration from: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started
 */

class MenuSearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    // Identifiers
    private let fromSearchToDiningLocationSegueID = "fromSearchToDiningLocationSegueID"
    
    // Singletons
    let provider = MenusProvider.shared
    let recentSearchesClass = RecentSearches.shared
    let searchOptions = SearchOptions.shared
    
    // Data
    var diningLocations = [DiningLocation]()
    var menuSRItems = [MenuSearchResultItem]()
    var optionsFilteredMenuSRItems = [MenuSearchResultItem]()
    var searchFilteredMenuSRItems = [MenuSearchResultItem]()
    var searchDay = "Today"
    var selectedDate = Date()
    
    // UI elements
    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var noResultsFooter: SearchNoResultsFooter!
    
    
    var dateFormatter = DateFormatter()
    func setDateFormatter() {
        dateFormatter.dateStyle = .short
    }
    
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        setDateFormatter()
        print(provider.todaysSearchResultItemsHaveLoaded)
            if searchOptions.selectedDate != selectedDate {
                selectedDate = searchOptions.selectedDate
            // If date is today
            if Calendar.current.isDateInToday(searchOptions.selectedDate) {
                setAsTodaysMeals()
                 // If date is some other date
            } else {
                searchController.searchBar.isUserInteractionEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.hideActivityIndicator()
                self.showActivityIndicator()
                getMealsForSearch()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu Search"
        self.tableView.tableFooterView = noResultsFooter
        
        // Search visuals
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search menu items..."
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = UIColor.umMaize
        searchController.searchBar.scopeButtonTitles = ["All", "Breakfast", "Lunch", "Dinner"]
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true

        // iOS checking from comments in https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.hideActivityIndicator()
        self.showActivityIndicator()
        self.setAsTodaysMeals()
       NotificationCenter.default.addObserver(self, selector: #selector(setAsTodaysMeals), name: .todaysSearchResultItemsHaveLoaded, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Activity Indicator
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
        self.tableView.allowsSelection = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Setting meals using MenuProvider
    @objc func setAsTodaysMeals() {
        if provider.todaysSearchResultItemsHaveLoaded {
            menuSRItems = provider.todaysSearchResultItems
            self.optionsFilteredMenuSRItems = self.filteredForDiningLocations()
            self.optionsFilteredMenuSRItems = self.filteredForAllergens()
            self.searchController.searchBar.isUserInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideActivityIndicator()
        }
    }

    
    func getMealsForSearch() {
        for diningLocation in provider.diningLocations {
            MenusAPIManager.getMeals(for: diningLocation, on: selectedDate) { (mealsFromAPI) in
                for meal in mealsFromAPI {
                    if meal.type == .breakfast || meal.type == .lunch  || meal.type == .dinner {
                        if meal.courses != nil {
                            for c in 0..<meal.courses!.count {
                                for menuItem in meal.courses![c].menuItems {
                                    self.menuSRItems.append(MenuSearchResultItem(menuItem: menuItem, for: meal.type.rawValue, in: c, at: diningLocation.name, on: self.selectedDate))
                                }
                            }
                        }
                    }
                }
                // Last dining loaction
                if diningLocation == self.provider.diningLocations.last {
                    self.optionsFilteredMenuSRItems = self.filteredForDiningLocations()
                    self.optionsFilteredMenuSRItems = self.filteredForAllergens()
                    self.searchController.searchBar.isUserInteractionEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        let scope = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    /// Returns true if the text is empty or nil
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchFilteredMenuSRItems = optionsFilteredMenuSRItems.filter({( menuSRItem : MenuSearchResultItem) -> Bool in
            let doesCategoryMatch = (scope == "All") || (menuSRItem.mealName == scope)
            return doesCategoryMatch && menuSRItem.menuItem.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    /// When user searches and presses enter, search text will save as recent search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recentSearchesClass.addRecentSearch(recentSearch: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // MARK: - Filtering for additional options
    func filteredForDiningLocations() -> [MenuSearchResultItem] {
        return menuSRItems.filter({ (menuSRItem) -> Bool in {
            return searchOptions.tempDiningLocationSettings.contains(menuSRItem.diningLocationName)
            }()
        })
    }
    
    func filteredForAllergens() -> [MenuSearchResultItem] {
       return optionsFilteredMenuSRItems.filter { $0.menuItem.allergens.first(where: { Set(searchOptions.tempAllergenSettings).contains($0) }) == nil }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchBarIsEmpty() {
                if recentSearchesClass.recentSearches.count > 0 {
                    self.noResultsFooter.hide()
                    return recentSearchesClass.recentSearches.count + 1
                } else {
                    self.noResultsFooter.displayNoRecentSearches()
                    return 0
                }
                
            } else {
                if searchFilteredMenuSRItems.count == 0 {
                    self.noResultsFooter.displayNoSearchResults()
                } else {
                    self.noResultsFooter.hide()
                }
                return searchFilteredMenuSRItems.count
            }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchBarIsEmpty() {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearchHeaderTableViewCellID", for: indexPath) as! RecentSearchHeaderTableViewCell
                cell.selectionStyle = .none
                cell.recentSearchLabel.text = "Recent Searches"
                cell.clearButton.isHidden = false
                cell.clearButton.addTarget(self, action: #selector(clearRecentSearches(sender:)), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearchTableViewCellID", for: indexPath) as! RecentSearchTableViewCell
                cell.recentSearchLabel.text = recentSearchesClass.recentSearches[indexPath.row - 1]
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuSearchMenuItemTableViewCellID", for: indexPath) as! MenuSearchMenuItemTableViewCell
            cell.menuItemNameLabel.text = searchFilteredMenuSRItems[indexPath.row].menuItem.name
            cell.favoriteControl.menuItemName = searchFilteredMenuSRItems[indexPath.row].menuItem.name
            cell.diningLocationNameLabel.text = searchFilteredMenuSRItems[indexPath.row].diningLocationName
            cell.mealLabel.text = searchFilteredMenuSRItems[indexPath.row].mealName
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searchBarIsEmpty() {
            performSegue(withIdentifier: fromSearchToDiningLocationSegueID, sender: self)
        } else if indexPath.row > 0 {
            // If a recent search is selected, search bar searches for that recent search
            searchController.searchBar.text = recentSearchesClass.recentSearches[indexPath.row - 1]
            filterContentForSearchText(searchController.searchBar.text!)
        }
       tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /// Clears recent searches
    @objc func clearRecentSearches(sender: UIButton) {
        recentSearchesClass.recentSearches = []
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Sends over search result and selected day, and sets dining location name
        if segue.identifier == fromSearchToDiningLocationSegueID {
            if let diningLocationVC = segue.destination as? DiningLocationViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    diningLocationVC.diningLocationName = searchFilteredMenuSRItems[indexPath.row].diningLocationName
                    diningLocationVC.selectedMenuSRI = searchFilteredMenuSRItems[indexPath.row]
                    diningLocationVC.selectedDay = selectedDate
                    
                }
            }
            
        }
    }
}
