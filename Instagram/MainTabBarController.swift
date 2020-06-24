//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let vc = UserProfileController(collectionViewLayout: layout)
        let navbar = UINavigationController(rootViewController: vc)
        
        navbar.tabBarItem.image = UIImage(named: "profile_unselected")
        navbar.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navbar]
    }
}
