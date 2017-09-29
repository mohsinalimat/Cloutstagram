//
//  MainTabBarController.swift
//  Cloutstagram
//
//  Created by sana on 2017-09-28.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit

// Create a screen for navigation
class MainTabBarController: UITabBarController {
    
    // Override when loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow grids to flow onto its layout
        let layout = UICollectionViewFlowLayout()
        
        // For the profile page
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        // Adding tab pictures
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        // Colour of the tab bar pictures
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    
    }
    
}
