//
//  UserSearchController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/8/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
   lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter search text"
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        navigationController?.navigationBar.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -8),
            ])
            
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.alwaysBounceVertical = true
        
        fetchUsers()
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers() {
            let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
        guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, value) in
                guard let userDict = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDict)
                self.users.append(user)
            }
            
            self.users.sort { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            }
            
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 66)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
          }
        }
       
        self.collectionView.reloadData()
    }
}
