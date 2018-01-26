//
//  Extensions.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/9/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    
    static let diningLocationsHaveLoaded = Notification.Name("DiningLocationsHaveLoaded")
    
    static let openNowHasLoaded = Notification.Name("OpenNowHasLoaded")
    
    static let defaultDiningLocationNameChanged = Notification.Name("DefaultDiningLocationNameChanged")
    
    static let todaysMealsHaveLoaded = Notification.Name("TodaysMealsHaveLoaded")
    static let todaysMenuItemsHaveLoaded = Notification.Name("TodaysMenuItemsHaveLoaded")
    static let todaysSearchResultItemsHaveLoaded = Notification.Name("TodaysSearchResultItemsHaveLoaded")
    
    static let tomorrowsMealsHaveLoaded = Notification.Name("TomorrowsMealsHaveLoaded")
    static let tomorrowsMenuItemsHaveLoaded = Notification.Name("TomorrowsMenuItemsHaveLoaded")
    
    static let todayAndTomorrowsMenuItemsHaveLoaded = Notification.Name("TodayAndTomorrowsMenuItemsHaveLoaded")
    
    static let favoriteChanged = Notification.Name("FavoriteChangedNotification")
    
}

extension UIColor {
    static let umMaize = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 1)
    static let umBlue = UIColor(red: 0/255, green: 39/255, blue: 76/255, alpha: 1)
    static let transparent = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    static let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    static let canhamPoolBlue = UIColor(red: 88.0/225, green: 122.0/225, blue: 188.0/225, alpha: 1)
}
