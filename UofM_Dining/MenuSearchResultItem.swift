//
//  MenuSearchResultItem.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/1/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation

public class MenuSearchResultItem {
    
    // MenuItem
    public let menuItem: MenuItem
    
    // Meal Name
    public let mealName: String
    
    // Course Index (used when scrolling to item after segue to diningLocationViewController)
    public let mealCourseIndex: Int
    
    // Dining Location
    public let diningLocationName: String
    
    // Date menuItem was accessed
    public let date: Date
    
    // Initializer
    init(menuItem: MenuItem, for mealName: String, in mealCourseIndex: Int, at diningLocationName: String, on date: Date) {
        self.menuItem = menuItem
        self.mealName = mealName
        self.mealCourseIndex = mealCourseIndex
        self.diningLocationName = diningLocationName
        self.date = date
    }
}
