//
//  UserProfilePhotoCELL.swift
//  Cloutstagram
//
//  Created by sana on 2017-10-05.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            print(post?.imageUrl ?? "")
            
            // Get the image url
            guard let imageUrl = post?.imageUrl else { return }
            
            // Here's the url
            guard let url = URL(string: imageUrl) else { return }
            
            // Fetch the post
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print("Failed to fetch post image: ", err)
                    return
                }
                
                // Get the image data
                guard let imageData = data else { return }
                
                // Here's the image
                let photoImage = UIImage(data: imageData)
                
                // Post image to screen
                DispatchQueue.main.async {
                    self.photoImageView.image = photoImage
                }
            }.resume()
        }
    }
    
    // How each image cell on the profile will look
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

