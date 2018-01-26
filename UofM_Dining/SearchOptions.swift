//
//  SearchOptions.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/10/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation

public class SearchOptions {
    
    static let shared = SearchOptions()
    
    let provider = MenusProvider.shared
    
    /// Default selected date is today
    var selectedDate = Date()
    
    /// The array of recent searches
    public var diningLocationNameList: [String] = []
    public var diningLocationSettings: [String]
    public var tempDiningLocationSettings: [String]
    
    /// List of all possible llergens
    public let allergenList: [String] = ["eggs", "fish", "milk", "oats", "peanuts", "pork", "sesame seed", "shellfish", "soy", "tree nuts", "wheat/barley/rye"]
    /// Array of allergenSettings
    public var allergenSettings: [String]
    public var tempAllergenSettings: [String]
    
    /// Sets temp values to permanent values, so they will save to user defaults
    public func saveSettingsAsDefault() {
        diningLocationSettings = tempDiningLocationSettings
        allergenSettings = tempAllergenSettings
        
    }
    /// Saves settings to user defaults
    public func saveSettingsToUserDefaults() {
        //        diningLocationSettings = tempDiningLocationSettings
        UserDefaults.standard.set(diningLocationSettings, forKey: "diningLocationSettings")
        
        //allergenSettings = tempAllergenSettings
        UserDefaults.standard.set(allergenSettings, forKey: "allergenSettings")
    }
    
    public func resetSettings() {
        allergenSettings = []
        diningLocationSettings = diningLocationNameList
    }
    /// If search options have not yet been set, need to set all dining locations as default settings
    var needToSetDefaultDiningLocationSettings: Bool
    
    /// Sets all dining locations as default settings
    @objc func getFirstDefaultDiningLocationSettings() {
        for diningLocation in provider.diningLocations {
            if needToSetDefaultDiningLocationSettings {
                diningLocationSettings.append(diningLocation.name)
                tempDiningLocationSettings.append(diningLocation.name)
            }
            diningLocationNameList.append(diningLocation.name)
        }
    }
    
    // Initializer
    init() {
        if let previousDiningLocationSettings = UserDefaults.standard.object(forKey: "diningLocationSettings") as! [String]? {
            needToSetDefaultDiningLocationSettings = false
            diningLocationSettings = previousDiningLocationSettings
            tempDiningLocationSettings = previousDiningLocationSettings
        } else {
            needToSetDefaultDiningLocationSettings = true
            diningLocationSettings = []
            tempDiningLocationSettings = []
        }
        if let previousAllergenSettings = UserDefaults.standard.object(forKey: "allergenSettings") as! [String]? {
            allergenSettings = previousAllergenSettings
            tempAllergenSettings = previousAllergenSettings
        } else {
            allergenSettings = []
            tempAllergenSettings = []
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getFirstDefaultDiningLocationSettings), name: .diningLocationsHaveLoaded, object: nil)
    }
}
