//
//  User.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/2/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let photoImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.photoImageUrl = dictionary["photo"] as? String ?? ""
    }
}
