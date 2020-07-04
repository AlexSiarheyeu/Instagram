//
//  HomeController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/4/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.backgroundColor = .white
        
        setupNaviagationItems()
        fetchPosts()
    }
    
    //MARK: - setup collection view
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    
    //MARK: - Private methods
    
    fileprivate func setupNaviagationItems() {
       // navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let reference = Database.database().reference().child("posts").child(uid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach { (key, value) in
                guard let dict = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dict)
                self.posts.append(post)
            }
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch photos", error)
        }
    }

}
