//
//  MainTabBarController.swift
//  Cloutstagram
//
//  Created by sana on 2017-09-28.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit
import Firebase
// Create a screen for navigation
class MainTabBarController: UITabBarController {
    
    // Override when loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If a user has no login info ..
        if Auth.auth().currentUser == nil {
            
            // Bring screen back to the main thread
            DispatchQueue.main.async {
                // Show this screen if not logged in
                let loginController = LoginController()
                
                let navController = UINavigationController(rootViewController: loginController)
                
                self.present(navController, animated: true, completion: nil)
            }
            
            return 
        }
        
        setupViewControllers()

    }
    
    func setupViewControllers() {
        
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
