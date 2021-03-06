//
//  UserProfile.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/24/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            guard let imageUrl = self.user?.photoImageUrl else { return }
            
            profileImageView.loadImage(urlString: imageUrl)
            usernameLabel.text = user?.username
            setupEditFollowButton()
        }
    }
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let listButton: UIButton = {
        let listB = UIButton(type: .system)
        listB.setImage(UIImage(named: "list"), for: .normal)
        listB.translatesAutoresizingMaskIntoConstraints = false
        listB.tintColor = UIColor(white: 0, alpha: 0.2)
        return listB
    }()
    
    let bookmarkButton: UIButton = {
        let bookmarkB = UIButton(type: .system)
        bookmarkB.setImage(UIImage(named: "ribbon"), for: .normal)
        bookmarkB.translatesAutoresizingMaskIntoConstraints = false
        bookmarkB.tintColor = UIColor(white: 0, alpha: 0.2)
        return bookmarkB
    }()
    
    let gridButton: UIButton = {
        let gridB = UIButton(type: .system)
        gridB.setImage(UIImage(named: "grid"), for: .normal)
        gridB.translatesAutoresizingMaskIntoConstraints = false
        return gridB
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
       let posts = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
        
        posts.attributedText = attributedText
        posts.textAlignment = .center
        posts.numberOfLines = 0
        return posts
    }()
    
    let followersLabel: UILabel = {
       let followers = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
               
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
        
        followers.attributedText = attributedText
        followers.textAlignment = .center
        followers.numberOfLines = 0
        return followers
    }()
    
    let followingLabel: UILabel = {
       let following = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                     
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
        
        following.attributedText = attributedText
        following.textAlignment = .center
        following.numberOfLines = 0
        return following
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Setup header view

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(editProfileFollowButton)
        
        //Constraints for Profile Image View
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 12),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
        //Constraints for Username Label
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])

        //fileprivate methods call
        setupBottomToolBar()
        setupUserStatsView()
    }
    
    //MARK: - Action methods for selectors
 
  @objc func handleEditProfileOrFollow() {
      
      guard let currentLoggedInUserId =  Auth.auth().currentUser?.uid else { return }
      guard let userId = user?.uid else { return }
      
    
    if editProfileFollowButton.titleLabel?.text == "Unfollow" {
        
        //unfollow
        Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (error, reference) in
            if let error = error {
                print("Failed to unfollow user", error)
                return
            }
            self.setupFollowStyle()
        }
    } else {
        
        //follow
        let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
        
        let values = [userId: 1]
        ref.updateChildValues(values) { (error, reference) in
            
            if let error = error {
                print("Failed to follow user", error)
                return
            }
            
            //successfully followed user
            self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
            self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            self.editProfileFollowButton.backgroundColor = .white
        }
    }
  }
    
    //MARK: Private methods
    
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            
        } else {
            
            //check if following
            
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value) { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.setupFollowStyle()
                }
            }
        }
    }

    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 12),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            editProfileFollowButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            editProfileFollowButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            editProfileFollowButton.leadingAnchor.constraint(equalTo: postsLabel.leadingAnchor),
            editProfileFollowButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor),
            editProfileFollowButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    fileprivate func setupBottomToolBar() {
        
        let bottomDeviderView = UIView()
        bottomDeviderView.translatesAutoresizingMaskIntoConstraints = false
        bottomDeviderView.backgroundColor = UIColor.lightGray
        
        let topDeviderView = UIView()
        topDeviderView.translatesAutoresizingMaskIntoConstraints = false
        topDeviderView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        addSubview(stackView)
        addSubview(bottomDeviderView)
        addSubview(topDeviderView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            topDeviderView.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            topDeviderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            topDeviderView.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomDeviderView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            bottomDeviderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            bottomDeviderView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    fileprivate func setupFollowStyle() {

        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
