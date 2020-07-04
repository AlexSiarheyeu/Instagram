//
//  User.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/2/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let photoImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.photoImageUrl = dictionary["photo"] as? String ?? ""
    }
}
