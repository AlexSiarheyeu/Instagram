//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    

    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        
        //if user is not logged in, present controller
        if Auth.auth().currentUser == nil {

            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
         
        setupViewControllers()
    }
    
    //MARK: - Private methods
    func setupViewControllers() {
        
        //home icon
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "home_unselected"), selectedImage: UIImage(named:"home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search icon
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected"), selectedImage: UIImage(named: "search_selected"), rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //add post icon
        let addPosthNavController = templateNavController(unselectedImage: UIImage(named: "plus_unselected"), selectedImage: UIImage(named: "plus_unselected"))
        
        //like icon
        let likehNavController = templateNavController(unselectedImage: UIImage(named: "like_unselected"), selectedImage: UIImage(named: "like_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileControlelr = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileControlelr)
            
        userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        

        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, addPosthNavController, likehNavController, userProfileNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for items in items {
            items.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -8, right: 0)
        }
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
    
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    //MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let addPhotoController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: addPhotoController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        
        return true
    }
}
