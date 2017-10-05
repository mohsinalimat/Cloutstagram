//
//  PhotoSelectorCell.swift
//  Cloutstagram
//
//  Created by sana on 2017-10-04.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit

// Display images into a grid
class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // Resize picture to fit grids to fit smaller sizes
        iv.clipsToBounds = true // Stay in bounds of a cell
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        backgroundColor = .brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }
    
}
