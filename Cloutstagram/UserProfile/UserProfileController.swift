//
//  UserProfileController.swift
//  Cloutstagram
//
//  Created by sana on 2017-09-28.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit
import Firebase
// Making the user profile screen
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    // Onload fill up screen with info
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        fetchUser()
        
        // Build header section
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    // 7 cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    // Grab the cells and fill them
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .purple
        
        return cell
    }
    
    // Spacing between cells left-to-right
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Spacing between cells bottom-to-top
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Width / 3 of screen size minus 2 lines between cells
        let width = (view.frame.width - 2) / 3
        
        // It's a square
        return CGSize(width: width, height: width)
        
    }
    
    // Making a header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    // Create the var user
    var user: User?
    
    // Fetch user information
    fileprivate func fetchUser() {
        
        // Grab User ID
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Fetch a snapshot of a user using their uid
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            // Access snapshot value into a dictionary
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            // Create a user object with a username and profileImageUrl
            self.user = User(dict: dict)
            
            // Place username onto the navigation title
            self.navigationItem.title = self.user?.username
        
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user: ", err)
        }
    }
}


// User info struct
struct User {
    let username: String
    let profileImageUrl: String
    
    // Get username and profilImageUrl for the user
    init(dict: [String: Any]) {
        self.username = dict["username"] as? String ?? ""
        self.profileImageUrl = dict["profileImageUrl"] as? String ?? ""
    }
}
