//
//  Post.swift
//  Cloutstagram
//
//  Created by sana on 2017-10-05.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import Foundation

// Structure of a picture
struct Post {
    let imageUrl: String
    
    init(dict: [String: Any]){
        self.imageUrl = dict["imageUrl"] as? String ?? ""
    }
}
