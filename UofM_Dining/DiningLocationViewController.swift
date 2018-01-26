//
//  DiningLocationViewController.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 11/21/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//
/* Comments
 -Tableview cell height specified in Main.storyboard
 */

import UIKit
import AudioToolbox

class DiningLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    // Identifiers
    private let menuItemCellID = "menuitemcellid"
    private let setDefaultDiningLocationSegueID = "setDefaultDiningLocationSegueID"
    private let setDefaultDiningLocationAlertVCID = "setDefaultDiningLocationAlertVCID"
    
    // Singletons
    let provider = MenusProvider.shared
    
    // UI elements
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealSelector: UISegmentedControl!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var footer: DiningLocationViewFooter!
    @IBOutlet weak var addDayButton: UIButton!
    @IBOutlet weak var subtractDayButton: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    
    
    /// This represents the location we are displaying for
    var diningLocationName = MenusProvider.shared.defaultDiningLocationName
    var selectedDiningLocation: DiningLocation?
    var meals = [Meal]()
    var bldOnlyMeals = [Meal]()
    var currentMealIndex: Int = 0
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    var currentHour: Int!
    var selectedDay = Date()
    var lowerBoundDate: Date!
    var selectedMenuSRI: MenuSearchResultItem?
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If user has not launched app before, known by user default, make user select default dining location
        let hasLaunchedBefore: Bool = UserDefaults.standard.bool(forKey: "AppHasLaunchedBefore")
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "AppHasLaunchedBefore")
            // Present view for user to select default dining location
            let setDefaultDiningLocationAlertVC = (
                storyboard?.instantiateViewController(
                    withIdentifier: setDefaultDiningLocationAlertVCID)
                )!
            setDefaultDiningLocationAlertVC.view.backgroundColor = UIColor.clear
            setDefaultDiningLocationAlertVC.modalTransitionStyle = .crossDissolve
            setDefaultDiningLocationAlertVC.modalPresentationStyle = .overCurrentContext
            present(setDefaultDiningLocationAlertVC, animated: true, completion: nil)
        }
        
        // Table view background color
        self.view.backgroundColor = UIColor.umBlue
        self.menuTableView.backgroundColor = UIColor.umBlue
        
        // Disable buttons
        self.addDayButton.isEnabled = false
        self.subtractDayButton.isEnabled = false
        
        // Visuals
        updateDateLabel()
        self.menuTableView.tableFooterView = footer
        
        // Set up currentTime
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: today)
        currentHour = components.hour!
        
        // Elements disabled until data is loaded
        self.addDayButton.isEnabled = false
        self.subtractDayButton.isEnabled = false
        
        initializeDates()
        
        // Below variation occurs when coming from DiningLocationsTableViewController
        if let diningLocation = selectedDiningLocation {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            diningLocationName = diningLocation.name
            self.title = diningLocationName
            getMenu(on: selectedDay)
            // Below variation will occur when coming from MenuSearchTableViewController
        } else if selectedMenuSRI != nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.title = diningLocationName
            findDiningLocationAndGetMenuFromSearchPage()
            // Below variation will occur at favorite page
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.title = provider.defaultDiningLocationName
            hideActivityIndicator()
            showActivityIndicator()
            NotificationCenter.default.addObserver(self, selector: #selector(setMealsForToday), name: .todaysMealsHaveLoaded, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(setMealsForTomorrow), name: .tomorrowsMealsHaveLoaded, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(reloadHomePage), name: .defaultDiningLocationNameChanged, object: nil)
            self.title = "Favorite Location"
            setMealsForToday()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification Selectors
    @objc func setMealsForToday() {
        if provider.todaysMealsHaveLoaded {
            findDiningLocationAndGetMenuForDefaultDiningLocation()
        }
    }
    @objc func setMealsForTomorrow() {
        if provider.tomorrowsMealsHaveLoaded {
            findDiningLocationAndGetMenuForDefaultDiningLocation()
        }
    }
    
    // MARK: - View Configuration
    /// Gets menu for new days
    func getMenu(on date: Date) {
        self.addDayButton.isEnabled = false
        self.subtractDayButton.isEnabled = false
        self.hideActivityIndicator()
        self.showActivityIndicator()
        if date.timeIntervalSince(today) <= 86400 && date.timeIntervalSince(today) >= 0 {
        //if dateFormatter.string(from: selectedDay) == dateFormatter.string(from: today) {
            if provider.todaysMealsHaveLoaded {
                meals = provider.todaysMeals[diningLocationName]!
                self.configureNormalView()
            }
        } else if date.timeIntervalSince(tomorrow) <= 86400 && date.timeIntervalSince(tomorrow) >= 0 {
            if provider.tomorrowsMealsHaveLoaded {
                meals = provider.tomorrowsMeals[diningLocationName]!
                self.configureNormalView()
            }
        } else {
            MenusAPIManager.getMeals(for: self.selectedDiningLocation!, on: date)
            { (mealsFromAPI) in
                self.meals = mealsFromAPI
                self.configureNormalView()
            }
        }
    }
    
    func configureNormalView() {
        self.configureMeals()
        self.currentMealIndex = 0
        self.configureMealSelectorSegmentedControl()
        self.menuTableView.reloadData()
        self.addDayButton.isEnabled = true
        self.subtractDayButton.isEnabled = true
        self.hideActivityIndicator()
    }
    
    /// Finds default dining location
    func findDiningLocationAndGetMenuForDefaultDiningLocation() {
        // find dining location with specified name
        for diningLocation in provider.diningLocations {
            if diningLocation.name == self.diningLocationName {
                self.selectedDiningLocation = diningLocation
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.title = diningLocationName
                
                // get menu items
                self.getMenu(on: self.selectedDay)
                break
            }
        }
    }
    
    func findDiningLocationAndGetMenuFromSearchPage() {
        // find dining location with specified name
        for diningLocation in provider.diningLocations {
            if diningLocation.name == self.diningLocationName {
                self.selectedDiningLocation = diningLocation
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.title = diningLocationName
                
                // get menu items
                self.getMenuFromSeachPage(on: self.selectedDay)
                break
            }
        }
    }
    func getMenuFromSeachPage(on date: Date) {
        self.addDayButton.isEnabled = false
        self.subtractDayButton.isEnabled = false
        self.hideActivityIndicator()
        self.showActivityIndicator()
        if dateFormatter.string(from: selectedDay) == dateFormatter.string(from: today) {
            self.meals = provider.todaysMeals[diningLocationName]!
            configureSearchView()
        } else {
            MenusAPIManager.getMeals(for: self.selectedDiningLocation!, on: date)
            { (mealsFromAPI) in
                self.meals = mealsFromAPI
                self.configureSearchView()
            }
        }
    }
    
    func configureSearchView() {
        self.configureMeals()
        // Set meal and segmented control
        for mealIndex in 0..<self.bldOnlyMeals.count {
            if self.bldOnlyMeals[mealIndex].type.rawValue == self.selectedMenuSRI!.mealName {
                self.currentMealIndex = mealIndex
                self.configureMealSelectorSegmentedControl()
                break
            }
        }
        
        self.menuTableView.reloadData()
        self.scrollToSelectedMenuSRItem()
        self.selectedMenuSRI = nil
        
        self.addDayButton.isEnabled = true
        self.subtractDayButton.isEnabled = true
        self.hideActivityIndicator()
    }
    
    
    func scrollToSelectedMenuSRItem() {
        let section = selectedMenuSRI!.mealCourseIndex
        var row = 0
        for menuItemIndex in 0..<bldOnlyMeals[currentMealIndex].courses![section].menuItems.count {
            if bldOnlyMeals[currentMealIndex].courses![section].menuItems[menuItemIndex].name == selectedMenuSRI?.menuItem.name {
                row = menuItemIndex
                break
            }
        }
        let selectionIndexPath = IndexPath(item: row, section: section)
        menuTableView.scrollToRow(at: selectionIndexPath, at: .top, animated: true)
    }
    
    /**
     Currently, we only display Breakfast, Lunch, and Dinenr, and no tranisition meals nor other meals
     */
    func configureMeals() {
        bldOnlyMeals.removeAll()
        for meal in meals {
            if meal.type == .breakfast || meal.type == .lunch || meal.type == .dinner {
                if meal.courses != nil {
                    bldOnlyMeals.append(meal)
                }
            }
        }
        // Checks to make sure meal index is within the correct range
        while currentMealIndex >= bldOnlyMeals.count {
            currentMealIndex -= 1
        }
        if currentMealIndex < 0 {
            currentMealIndex = 0
        }
    }
    
    /// Configures segmented control so it shows the relevant meals
    func configureMealSelectorSegmentedControl() {
        mealSelector.removeAllSegments()
        for meal in bldOnlyMeals {
            mealSelector.insertSegment(withTitle: meal.type.rawValue, at: mealSelector.numberOfSegments, animated: false)
        }
        mealSelector.isHidden = false
        mealSelector.selectedSegmentIndex = currentMealIndex
    }
    
    /// Sets currentMealIndex to correct index based off current time of day
    func setMealBasedOnTime() {
        if currentHour > 1 && currentHour < 11 {
            currentMealIndex = 1
        } else {
            currentMealIndex = 2
        }
    }
    
    func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        if dateFormatter.string(from: selectedDay) == dateFormatter.string(from: today) {
            dateLabel.text = "Today"
        } else {
            let dateString = dateFormatter.string(from: selectedDay)
            dateLabel.text = dateString
        }
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator() {
        menuTableView.allowsSelection = false
        self.mealSelector.isEnabled = false
        
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
        self.view.addSubview(self.activityIndicator)
    }
    
    func hideActivityIndicator() {
        menuTableView.allowsSelection = true
        self.mealSelector.isEnabled = true
        self.activityIndicator.stopAnimating()
    }
    
    
    // MARK: - Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if bldOnlyMeals.count > 0 {
            self.footer.hide()
            return bldOnlyMeals[currentMealIndex].courses!.count
        } else {
            self.footer.displayNoMeal()
        }
        return 1
    }
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.canhamPoolBlue
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 2, width: 350, height: 24)
        label.text = ""
        if bldOnlyMeals.count > 0 {
            label.text = bldOnlyMeals[currentMealIndex].courses![section].name
        }
        view.addSubview(label)
        return view
    }
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bldOnlyMeals.count > 0 {
            return bldOnlyMeals[currentMealIndex].courses![section].menuItems.count
        }
        return 0
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuItemCellID, for: indexPath) as! MenuItemTableViewCell
        // Fetches the appropriate MenuItem for the data source layout
        let menuItem = bldOnlyMeals[currentMealIndex].courses![indexPath.section].menuItems[indexPath.row]
        // Configure the cell
        cell.menuItemLabel.text = menuItem.name
        cell.favoriteControl.menuItemName = menuItem.name
        
        if selectedDiningLocation?.type != .diningHall {
            if let price = menuItem.price {
                cell.priceLabel.isHidden = false
                cell.priceLabel.text = "$" + String(format:"%.2f", price)
            }
        } else {
            cell.priceLabel.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: Actions
    @objc func reloadHomePage() {
        selectedDiningLocation = nil
        selectedDay = today
        updateDateLabel()
        diningLocationName = provider.defaultDiningLocationName
        findDiningLocationAndGetMenuForDefaultDiningLocation()
        self.menuTableView.reloadData()
    }
    
    @IBAction func selectMeal(_ sender: UISegmentedControl) {
        currentMealIndex = sender.selectedSegmentIndex
        menuTableView.reloadData()
    }
    
    /* source: http://swiftdeveloperblog.com/code-examples/add-days-months-or-years-to-current-date-in-swift/ */
    @IBAction func incrementDay(_ sender: UIButton) {
        if canIncrementDate {
            selectedDay = checkValidDate(date: Calendar.current.date(byAdding: .day, value: 1, to: selectedDay)!)
            updateDateLabel()
            getMenu(on: selectedDay)
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @IBAction func decrementDay(_ sender: UIButton) {
        if canDecrementDate {
            selectedDay = checkValidDate(date: Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)!)
            updateDateLabel()
            getMenu(on: selectedDay)
        } else {
            AudioServicesPlaySystemSound(1102)
        }
    }
    
    
    // MARK: - Date Functions
    let dateFormatter = DateFormatter()
    
    var canIncrementDate = true
    var canDecrementDate = true
    
    func checkValidDate(date: Date) -> Date {
        let upperBoundDate = Calendar.current.date(byAdding: .day, value: 3, to: today)!
        
        if date <= lowerBoundDate {
            canDecrementDate = false
            return lowerBoundDate
        } else if date >= upperBoundDate {
            canIncrementDate = false
            return upperBoundDate
        }
        canDecrementDate = true
        canIncrementDate = true
        return date
    }
    
    func initializeDates() {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        lowerBoundDate = dateFormatter.date(from: "2016/11/21 9:31")
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // If going to info page, send over dining location
        if segue.identifier == "Info" {
            if let infoNC = segue.destination as? UINavigationController {
                let infoVC = infoNC.viewControllers.first as! InfoViewController
                infoVC.diningLocation = selectedDiningLocation!
            }
            
            // If going to nutritional value page, send over the selected menu item
        } else if segue.identifier == "NutritionValueSegue" {
            if let nutritionvalueTVC = segue.destination as? NutritionValueTableViewController {
                if let cell = sender as? UITableViewCell {
                    if let indexPath = menuTableView.indexPath(for: cell) {
                        nutritionvalueTVC.myMenuItem = bldOnlyMeals[currentMealIndex].courses![indexPath.section].menuItems[indexPath.row]
                    }
                }
            }
        }
    }
}
