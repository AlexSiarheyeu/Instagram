//
//  Post.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/2/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

struct Post {
    var imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        
    }
}
