//
//  InfoViewController.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 11/29/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation

/*
 Comments:
 * Deselected editable and selectable for the text view set in storyboard
 */
class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate {
    var diningLocation: DiningLocation!
    var diningLocationCoordinate: CLLocationCoordinate2D!
    
    let provider = MenusProvider.shared
    
    // MARK: - Properties
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hoursTextLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var setDefaultButton: UIButton!
    
    // MARK: - Current Location
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.map.showsUserLocation = true
        self.map.showsCompass = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = diningLocation.name
        // self.setDefaultButton.titleLabel?.text = "Set \(diningLocation.name) to your default dining location"
        if diningLocation.name == provider.defaultDiningLocationName {
            setDefaultButton.isEnabled = false
            self.setDefaultButton.setTitle("\(diningLocation!.name) is your default dining location", for: .disabled)
        } else {
            self.setDefaultButton.setTitle("Set as default dining location", for: .normal)
        }
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        self.manager.startUpdatingLocation()
        let dininghallregion:CLLocationCoordinate2D = diningLocation.coordinate
        let mydiningLocation = diningLocation.coordinate
        let distancespan:CLLocationDegrees = 1000
        self.map.setRegion(MKCoordinateRegionMakeWithDistance(dininghallregion, distancespan, distancespan), animated: false)
        let mydininglocationPin = locationAnnotation(title: diningLocation.name, coordinate: mydiningLocation)
        self.map.addAnnotation(mydininglocationPin)
        
        // Sets address Label
        addressLabel.text = diningLocation.address.fullAddress
        
        
        // Set hours display
        // Clear any existing
        hoursTextLabel.text = ""
        hoursTextLabel.numberOfLines = diningLocation.hours.count
        var lineNum = 1
        for line in diningLocation.hours {
            hoursTextLabel.text?.append(line)
            if lineNum < diningLocation.hours.count {
                hoursTextLabel.text?.append("\n")
            }
            lineNum = lineNum + 1
        }
        
        // Set capacity label
        if diningLocation.capacity != nil {
            if diningLocation.currentOccupancy != nil {
                capacityLabel.text = "Capacity: " + String(diningLocation.currentOccupancy!) + "/" + (diningLocation.capacity!.description)
            } else {
                capacityLabel.text = "Capacity: " +  (diningLocation.capacity?.description)!
            }
        } else {
            capacityLabel.isHidden = true
        }
        
        // Set the phone label
        if diningLocation.contactPhone != nil {
            phoneButton.setTitle(diningLocation.contactPhone, for: .normal)
        } else {
            phoneButton.isEnabled = false
            phoneButton.isHidden = true
        }
        
        // Set email label
        if diningLocation.contactEmail != nil {
            emailButton.setTitle(diningLocation.contactEmail, for: .normal)
        } else {
            emailButton.isEnabled = false
            emailButton.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func getDirections(_ sender: UIBarButtonItem) {
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(diningLocation.coordinate, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: diningLocation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = diningLocation.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    /*
     Phone capabilities source:
     https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
     */
    @IBAction func callDiningLocation(_ sender: UIButton) {
        if let url = URL(string: "tel://\(diningLocation.contactPhone!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /*
     Mail Capabilities Source:
     https://www.youtube.com/watch?v=dsk-BDn6FCI
     */
    @IBAction func emailDiningLocation(_ sender: UIButton) {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setToRecipients([diningLocation.contactEmail!])
        if MFMailComposeViewController.canSendMail() {
            self.present(mailCompose, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setDLAsDefault(_ sender: UIButton) {
        setDefaultButton.isEnabled = false
        self.setDefaultButton.setTitle("Successfully set to default dining location!", for: .disabled)
        provider.changeDefaultDiningLocation(newDiningLocationName: diningLocation.name)
    }
    
    /// This closes the infoPage
    @IBAction func closeInfoPage(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
