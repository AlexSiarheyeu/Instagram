//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user is not logged in, present controller
        if Auth.auth().currentUser == nil {
            let navVC = UINavigationController(rootViewController: LoginController())
            navVC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        let vc = UserProfileController(collectionViewLayout: layout)
        let navbar = UINavigationController(rootViewController: vc)
        
        navbar.tabBarItem.image = UIImage(named: "profile_unselected")
        navbar.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navbar]
    }
}
