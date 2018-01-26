//
//  DiningLocationsTableViewController.swift
//  UMich Dining
//
//  Created by Ryan Kish on 11/20/17.
//  Copyright © 2017 Zucc. All rights reserved.
//

import UIKit
import CoreLocation


// MARK: Constants
private let diningLocationCellID = "diningLocationCellIdentifier"
private let venueTableViewControllerTitle = "Dining Locations"

class DiningLocationsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    
    // MARK: menuLoader
    let menuLoader = MenusProvider.shared
    
    
    // MARK: Properties
    @IBOutlet weak var centralNorthSelector: UISegmentedControl!
    @IBOutlet weak var footer: DiningLocationsViewFooter!
    
    // MARK: Activity Indicator
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: Variables
    var campus = "Central"
    let locationManager = CLLocationManager()
    // Location is initially set to the center of the diag
    // 42.276933, -83.738208
    var currentLocation = CLLocation(latitude: 42.276933, longitude: -83.738208)
    var distanceDict = [String:Double]()
    // Refresh control
    var refresher: UIRefreshControl!
    
    
    // MARK: Sort By Distance
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    func metersToMile(meters: Double) -> Double {
        //returns a double with 2 decimal places
        return floor((meters / 1609.344) / 0.01) * 0.01
    }
    
    func sortByDistance(unsortedArray: [DiningLocation]) -> [DiningLocation] {
        return unsortedArray.sorted(by: { location1, location2 in
            // Calculates the distance from each location to the users current location
            let d1 = currentLocation.distance(from: CLLocation(latitude: location1.coordinate.latitude, longitude: location1.coordinate.longitude))
            let d2 = currentLocation.distance(from: CLLocation(latitude: location2.coordinate.latitude, longitude: location2.coordinate.longitude))
            // populates the dictionary with the location names and distances
            self.distanceDict[location1.name] = self.metersToMile(meters: d1)
            self.distanceDict[location2.name] = self.metersToMile(meters: d2)
            // this is the sorting operator
            return d1 < d2
        })
    }
    
    // MARK: Refresh
    @objc func refresh() {
        if menuLoader.openNowHasLoaded {
            menuLoader.updateIsOpenNow()
        }
    }
    
    // MARK: - Dining Locations
    var diningLocations = [DiningLocation]()
    
    // Create array of locations on north campus
    var northLocations: [DiningLocation] {
        get {
            return diningLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.coordinate.latitude > 42.287288
            })
        }
    }
    
    // Create array of locations on central campus
    var centralLocations: [DiningLocation] {
        get {
            return diningLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.coordinate.latitude < 42.287288
            })
        }
    }
    
    // Central location type arrays
    var centralDiningHalls: [DiningLocation] {
        get {
            return centralLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .diningHall
            })
        }
    }
    
    // Creates an Array of the markets on Central Campus
    var centralMarkets: [DiningLocation] {
        get {
            return centralLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .market
            })
        }
    }
    
    // Creates an array of cafes on central campus
    var centralCafes: [DiningLocation] {
        get {
            return centralLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .cafe
            })
        }
    }
    
    // North location type arrays
    var northDiningHalls: [DiningLocation] {
        get {
            return northLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .diningHall
            })
        }
    }
    
    var northMarkets: [DiningLocation] {
        get {
            return northLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .market
            })
        }
    }
    
    var northCafes: [DiningLocation] {
        get {
            return northLocations.filter({ (diningLocation) -> Bool in
                return diningLocation.type == .cafe
            })
        }
    }
    
    var diningLocationTypes = ["Dining Halls", "Markets", "Cafes"]
    
    // Dictionary with dining hall name as key and a string describing its status as the value
    var openNowDict = [String: String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable campus selector
        self.centralNorthSelector.isEnabled = false
        self.hideActivityIndicator()
        self.showActivityIndicator()
        self.refresher = UIRefreshControl()
        self.refresher.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateIsOpenDict), name: .openNowHasLoaded, object: nil)
        self.title = venueTableViewControllerTitle
        self.updateIsOpenDict()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: Activity Indicator
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.canhamPoolBlue
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 2, width: 350, height: 24)
        label.text = diningLocationTypes[section]
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        // Checks what campus is selected and returns rows
        if campus == "Central" {
            if section == 0 {
                numberOfRows = centralDiningHalls.count
            } else if section == 1 {
                numberOfRows = centralMarkets.count
            } else if section == 2 {
                numberOfRows = centralCafes.count
            }
        }
        else {
            if section == 0 {
                numberOfRows = northDiningHalls.count
            } else if section == 1 {
                numberOfRows = northMarkets.count
            } else if section == 2 {
                numberOfRows = northCafes.count
            }
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: diningLocationCellID, for: indexPath) as! DiningLocationsTableViewCell
        
        // Fetches the appropriate Dining Location for the data source layout
        
        let diningLocation: DiningLocation
        
        // Checks campus
        switch campus {
        case "Central":
            if indexPath.section == 0 {
                diningLocation = centralDiningHalls[indexPath.row]
            } else if indexPath.section == 1 {
                diningLocation = centralMarkets[indexPath.row]
            } else {
                diningLocation = centralCafes[indexPath.row]
            }
            
        default:
            if indexPath.section == 0 {
                diningLocation = northDiningHalls[indexPath.row]
            } else if indexPath.section == 1 {
                diningLocation = northMarkets[indexPath.row]
            } else {
                diningLocation = northCafes[indexPath.row]
            }
        }
        
        // Configures and returns the cell
        cell.diningLocationName.text = diningLocation.name
        cell.openNow.text = openNowDict[diningLocation.name]
        if let distance = self.distanceDict[diningLocation.name] {
            cell.distance.text = String(format:"%.2f", distance) + " mi"
        }
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func changeCampus(_ sender: UISegmentedControl) {
        campus = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    @objc func updateIsOpenDict() {
        self.centralNorthSelector.isEnabled = false
        if menuLoader.openNowHasLoaded && menuLoader.diningLocationsHaveLoaded {
            self.openNowDict = menuLoader.openNowDict
            updateDiningLocations()
        }
    }
    
    @objc func updateDiningLocations() {
        if menuLoader.diningLocationsHaveLoaded && menuLoader.openNowHasLoaded {
            self.diningLocations = menuLoader.diningLocations
            self.diningLocations = self.sortByDistance(unsortedArray: self.diningLocations)
            self.hideActivityIndicator()
            self.refresher.endRefreshing()
            self.centralNorthSelector.isEnabled = true
            self.tableView.reloadData()
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // If a dining Hall cell is tapped on
        if segue.identifier == "DiningLocationCell" {
            // destination is a diningLocationViewController
            let diningLocationViewController = segue.destination as? DiningLocationViewController
            // Info is coming from a table cell
            let selectedDiningLocationCell = sender as? DiningLocationsTableViewCell
            
            guard let indexPath = tableView.indexPath(for: selectedDiningLocationCell!) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDiningLocation: DiningLocation?
            // have to use campus specific arrays
            if campus == "Central" {
                if indexPath.section == 0 {
                    selectedDiningLocation = centralDiningHalls[indexPath.row]
                } else if indexPath.section == 1 {
                    selectedDiningLocation = centralMarkets[indexPath.row]
                } else {
                    selectedDiningLocation = centralCafes[indexPath.row]
                }
            }
            else {
                if indexPath.section == 0 {
                    selectedDiningLocation = northDiningHalls[indexPath.row]
                } else if indexPath.section == 1 {
                    selectedDiningLocation = northMarkets[indexPath.row]
                } else {
                    selectedDiningLocation = northCafes[indexPath.row]
                }
            }
            // set the value of the dining location to be displayed on next screen
            diningLocationViewController!.selectedDiningLocation = selectedDiningLocation
        }
    }
}

