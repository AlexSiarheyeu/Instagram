//
//  Post.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/2/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

struct Post {
    let imageUrl: String
    let user: User
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
    }
}
