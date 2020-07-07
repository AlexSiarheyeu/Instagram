//
//  Database + Fetch.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/7/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completionHandler: @escaping (User) -> ()) {
        
       Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
           
           guard let userDictionary = snapshot.value as? [String: Any] else { return }
                     
           let user = User(uid: uid, dictionary: userDictionary)
        
           completionHandler(user)
           
       }) { (error) in
           print("Failed to fetch username", error)
       }
   }
}
