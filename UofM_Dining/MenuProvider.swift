//
//  MenuProvider.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/12/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation

final class MenusProvider {
    
    static let shared = MenusProvider()
    
    private let notifications = NotificationCenter.default
    
    let today = Date()
    
    // MARK: - Dining Locations
    public var diningLocations = [DiningLocation]()
    public var diningLocationsHaveLoaded = false {
        didSet {
            notifications.post(name: .diningLocationsHaveLoaded, object: nil)
            initTodaysData()
        }
    }
    
    // Open now
    public var openNowDict = [String: String]()
    public var openNowHasLoaded = false {
        didSet {
            self.delayAction(0.5) {
                self.notifications.post(name: .openNowHasLoaded, object: nil)
            }
        }
    }
    
    // Default
    public var defaultDiningLocationName = UserDefaults.standard.string(forKey: "defaultDiningLocationName") ?? "East Quad Dining Hall" {
        didSet {
            notifications.post(name: .defaultDiningLocationNameChanged, object: nil)
        }
    }
    
    public var defaultDiningLocation: DiningLocation?
    
    public func changeDefaultDiningLocation(newDiningLocationName: String) {
        self.defaultDiningLocationName = newDiningLocationName
        UserDefaults.standard.set(self.defaultDiningLocationName, forKey: "defaultDiningLocationName")
    }
    
    // MARK: - Meals and Menu Items
    /// Used for dining location view controller
    public var todaysMeals = [String:[Meal]]()
    public var todaysMealsHaveLoaded = false {
        didSet {
            notifications.post(name: .todaysMealsHaveLoaded, object: nil)
        }
    }
    /// Used for favorites
    public var todaysMenuItems = [MenuItem]()
    public var todaysMenuItemsHaveLoaded = false {
        didSet {
            notifications.post(name: .todaysMenuItemsHaveLoaded, object: nil)
        }
    }
    
    public var tomorrowsMeals = [String:[Meal]]()
    public var tomorrowsMealsHaveLoaded = false {
        didSet {
            notifications.post(name: .tomorrowsMealsHaveLoaded, object: nil)
        }
    }
    /// Used for favorites
    public var tomorrowsMenuItems = [MenuItem]()
    public var tomorrowsMenuItemsHaveLoaded = false {
        didSet {
            notifications.post(name: .tomorrowsMenuItemsHaveLoaded, object: nil)
            if self.todaysMenuItemsHaveLoaded {
                self.todayAndTomorrowMenuItemsHaveLoaded = true
            }
        }
    }
    
    public var todayAndTomorrowMenuItemsHaveLoaded = false {
        didSet {
            notifications.post(name: .todayAndTomorrowsMenuItemsHaveLoaded, object: nil)
        }
    }
    
    /// Used for search
    public var todaysSearchResultItems = [MenuSearchResultItem]()
    public var todaysSearchResultItemsHaveLoaded = false {
        didSet {
            notifications.post(name: .todaysSearchResultItemsHaveLoaded, object: nil)
        }
    }
    
    // Load open now after todays data has loaded
    public var todaysDataHasLoaded = false {
        didSet {
            self.initTomorrowsData()
        }
    }
    public var tomorrowsDataHasLoaded = false {
        didSet {
            updateIsOpenNow()
        }
    }
    
    
    // MARK: - Initializer
    private init() {
        initDiningLocations()
    }
    
    private func initDiningLocations() {
        MenusAPIManager.getDiningLocations { (diningLocations) in
            self.diningLocations = diningLocations
            self.diningLocationsHaveLoaded = true
            self.notifications.post(name: .diningLocationsHaveLoaded, object: nil)
        }
    }
    
    private func initTodaysData() {
        self.todaysMeals.removeAll()
        self.todaysMenuItems.removeAll()
        self.todaysSearchResultItems.removeAll()
        for location in self.diningLocations {
            MenusAPIManager.getMeals(for: location) { (mealsFromAPI) in
                let mealsForDiningLocation = mealsFromAPI
                self.todaysMeals[location.name] = mealsForDiningLocation
                for meal in mealsForDiningLocation {
                    if meal.type == .breakfast || meal.type == .lunch || meal.type == .dinner {
                        if meal.courses != nil {
                            for (c, course) in meal.courses!.enumerated() {
                                for menuItem in course.menuItems {
                                    menuItem.meal = meal.description
                                    if menuItem.meal == "Lunch Transition" {
                                        menuItem.meal = "Brunch"
                                    } else if menuItem.meal ==  "Dinner Transition" {
                                        menuItem.meal = "Dinner"
                                    }
                                    menuItem.diningLocationName = location.name
                                    self.todaysSearchResultItems.append(MenuSearchResultItem(menuItem: menuItem, for: meal.type.rawValue, in: c, at: location.name, on: self.today))
                                    self.todaysMenuItems.append(menuItem)
                                }
                            }
                        }
                    }
                }
                if location.name == self.diningLocations.last?.name {
                    self.todaysMealsHaveLoaded = true
                    self.todaysMenuItemsHaveLoaded = true
                    self.todaysSearchResultItemsHaveLoaded = true
                    self.todaysDataHasLoaded = true
                }
            }
        }
    }
    
    private func initTomorrowsData() {
        self.tomorrowsMeals.removeAll()
        self.tomorrowsMenuItems.removeAll()
        for location in self.diningLocations {
            MenusAPIManager.getMeals(for: location, on: Calendar.current.date(byAdding: .day, value: 1, to: Date())!) { (mealsFromAPI) in
                let mealsForDiningLocation = mealsFromAPI
                self.tomorrowsMeals[location.name] = mealsForDiningLocation
                
                for meal in mealsForDiningLocation {
                    if meal.type == .breakfast || meal.type == .lunch || meal.type == .dinner {
                        if meal.courses != nil {
                            for course in meal.courses! {
                                for menuItem in course.menuItems {
                                    menuItem.meal = meal.description
                                    if menuItem.meal == "Lunch Transition" {
                                        menuItem.meal = "Brunch"
                                    } else if menuItem.meal ==  "Dinner Transition" {
                                        menuItem.meal = "Dinner"
                                    }
                                    menuItem.diningLocationName = location.name
                                    self.tomorrowsMenuItems.append(menuItem)
                                }
                            }
                        }
                    }
                }
                if location === self.diningLocations.last {
                    self.tomorrowsMealsHaveLoaded = true
                    self.tomorrowsMenuItemsHaveLoaded = true
                    self.tomorrowsDataHasLoaded = true
                }
            }
        }
    }
    
    public func updateIsOpenNow() {
        self.openNowHasLoaded = false
        if diningLocationsHaveLoaded {
            for location in diningLocations {
                MenusAPIManager.isOpen(location, on: today) { open in
                    if open {
                        self.openNowDict[location.name] = "Open Now"
                    } else {
                        self.openNowDict[location.name] = "Closed"
                    }
                    if location.name == self.diningLocations.last?.name {
                        self.openNowHasLoaded = true
                    }
                }
            }
        }
    }
    
    // This function is from http://iosrevisited.blogspot.com/2017/08/dispatchafter-gcd-in-swift-swift-3.html
    public func delayAction(_ xSeconds:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + xSeconds
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
    
}
