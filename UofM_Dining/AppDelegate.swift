//
//  AppDelegate.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 11/20/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Favorites
        _ = FavoriteManager.shared
        
        // To show accurate UM color
        UINavigationBar.appearance().isTranslucent = false
        
        // Setting navigation background color
        UINavigationBar.appearance().barTintColor = UIColor.umBlue
        //UIColor(red:0.00784314, green:0.15686275, blue:0.29411765, alpha:1.0)
        
        // Setting navigation bar color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        // Setting nav bar title text color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        // Changing status bar color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // To show accurate UM color
        UITabBar.appearance().isTranslucent = false
        // Setting tab bar background color
        UITabBar.appearance().barTintColor = UIColor.umBlue
        
        // Setting tab bar title text color
        UITabBar.appearance().tintColor = UIColor.white
        
        
        // Segmented Control color
        UISegmentedControl.appearance().tintColor = UIColor.umMaize
        
        // Table View cells
        UITableViewCell.appearance().backgroundColor = UIColor.white
        
        UIButton.appearance().tintColor = UIColor.umMaize
        
        
        // Favorite control background
        FavoritesControl.appearance().backgroundColor = UIColor.transparent
        
        
        
        let tabBarController: UITabBarController = (self.window!.rootViewController as! UITabBarController)
        tabBarController.tabBar.items?[0].title = "Favorite Location"
        tabBarController.tabBar.items?[0].image = UIImage(named: "star")
        tabBarController.tabBar.items?[1].title = "Dining Locations"
        tabBarController.tabBar.items?[1].image = UIImage(named: "restaurant")
        tabBarController.tabBar.items?[2].title = "Menu Search"
        tabBarController.tabBar.items?[2].image = UIImage(named: "anotherSearch")
        tabBarController.tabBar.items?[3].title = "Favorites"
        tabBarController.tabBar.items?[3].image = UIImage(named: "heart")
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Saving user defaults
        // Saving default dining location name
        let defaultDiningLocationName = MenusProvider.shared.defaultDiningLocationName
        UserDefaults.standard.set(defaultDiningLocationName, forKey: "defaultDiningLocationName")
        // Recent searches
        let recentSearchesClass = RecentSearches.shared
        recentSearchesClass.saveRecentSearches()
        // Search options
        let searchOptionsClass = SearchOptions.shared
        searchOptionsClass.saveSettingsToUserDefaults()
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

