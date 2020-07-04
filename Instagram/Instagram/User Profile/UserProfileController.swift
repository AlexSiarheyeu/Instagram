//
//  UserProfileController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var posts = [Post]()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "cellId")
                
        
        setupLogOutButton()
        fetchUser()
        fetchOrderedPosts()
    }
    //MARK: - Action methods for selectors

    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionLogOut = UIAlertAction(title: "Log out", style: .destructive) { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutError  {
                print("\(signOutError)")
            }
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionLogOut)

        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    fileprivate func fetchOrderedPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
              
        let reference = Database.database().reference().child("posts").child(uid)
        
        reference.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(dictionary: dictionary)
            self.posts.append(post)
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Failed to fetch post", error)
        }
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }

            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            
            self.collectionView.reloadData()

            
        }) { (error) in
            print ("Failed to fetch user \(error)")
        }
    }
    
    fileprivate func setupLogOutButton() {
        let image = UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    //MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! UserProfilePhotoCell
        
        cell.posts = posts[indexPath.item]
        

        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}

