//
//  RecentSearches.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/9/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation

public class RecentSearches {
    
    static let shared = RecentSearches()
    
    /// The array of recent searches
    public var recentSearches: [String]
    
    private let maxNumberOfSearches = 5
    
    /// Adds search to front of array, and deletes oldest recent search if recent searches reaches maximum size
    public func addRecentSearch(recentSearch: String) {
        if recentSearches.count < maxNumberOfSearches {
            recentSearches.append(recentSearch)
        } else {
            recentSearches.removeLast()
            recentSearches.insert(recentSearch, at: 0)
        }
    }
    
    public func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    // Initializer
    init() {
        // If recent searches have been saved before, use those, otherwise, there are no searches in recent searches
        if let previousRecentSearches = UserDefaults.standard.object(forKey: "recentSearches") as! [String]? {
            recentSearches = previousRecentSearches
        } else {
            recentSearches = []
        }
    }
}
