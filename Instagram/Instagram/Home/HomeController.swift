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
    
    //MARK: - Properties

    let cellId = "cellId"
    var posts = [Post]()
    
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        setupNaviagationItems()
        fetchAllPosts()
    }
    
    //MARK: - Setup collection view
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 // how to 1 to 1 aspect ratio
        height += view.frame.width
        height += 50
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    //MARK: - Action methods for selectors
    
    @objc func handleRefresh() {
        //posts.removeAll()
        fetchAllPosts()
        collectionView.refreshControl?.endRefreshing() //??
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    //MARK: - Private methods
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUsersId()
    }
    
    fileprivate func fetchFollowingUsersId() {
        
         guard let uid = Auth.auth().currentUser?.uid else { return }
                
         Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapshot) in
  
        guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach { (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
          }
        }
      }
    }
    
    fileprivate func setupNaviagationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {

        let reference = Database.database().reference().child("posts").child(user.uid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView.refreshControl?.endRefreshing()
            
        guard let dictionary = snapshot.value as? [String: Any] else { return }

        dictionary.forEach { (key, value) in
            guard let dict = value as? [String: Any] else { return }
            let post = Post(user: user, dictionary: dict)
            self.posts.append(post)
        }
            
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            
            
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Failed to fetch photos", error)
        }
    }
}
