//
//  UserProfileController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
                
     fetchUser()
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String: Any]
            
            guard let username = dictionary["username"] as? String else { return }
            
            self.navigationItem.title = username
            
        }) { (error) in
            print ("Failed to fetch user \(error)")
        }
        
    }
}
