//
//  FavoriteManager.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/5/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    public var favArray = [String]()
    private let defaults = UserDefaults.standard
    
    init() {
        self.getFavorites()
    }
    
    
    // Toggles the favorite status for a given item
    public func toggleFavoriteStatus(itemName: String) {
        if let index = self.favArray.index(of: itemName) {
            self.favArray.remove(at: index)
        } else {
            self.favArray.append(itemName)
        }
        NotificationCenter.default.post(name: .favoriteChanged, object: nil)
        defaults.set(self.favArray, forKey: "Favorites")
    }
    
    private func getFavorites() {
        if let previousFavorites = defaults.array(forKey: "Favorites") as! [String]? {
            self.favArray = previousFavorites
        } else {
            self.favArray = []
        }
    }
    
    public func removeAll() {
        self.favArray.removeAll()
        defaults.set(self.favArray, forKey: "Favorites")
        NotificationCenter.default.post(name: .favoriteChanged, object: nil)
    }
    
}
