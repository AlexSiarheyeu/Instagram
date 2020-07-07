//
//  HomePostCell.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/4/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            guard let userImage = post?.user.photoImageUrl else { return }
            
            photoImageView.loadImage(urlString: imageUrl)
            usernameLabel.text = post?.user.username
            userProfileImageView.loadImage(urlString: userImage)
            //captionLabel.text = post?.caption
            setupAttributedCaption()
            
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleOptionsButton), for: .touchUpInside)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_unselected")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "comment")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send2")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ribbon")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var stackView = UIStackView()
    
    @objc func handleOptionsButton() {
        print("kdsmjdks;")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(userProfileImageView)
        userProfileImageView.layer.cornerRadius = 40/2

        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        addSubview(captionLabel)

        setupActionButtons()
        
        NSLayoutConstraint.activate([
            
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImageView.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8),
            photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            
            userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            userProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor),
            
            optionsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            optionsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            
 
            captionLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant:  10),
            captionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            captionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)

        ])
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
               
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
               
        attributedText.append(NSAttributedString(string: "1 w", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
               
        captionLabel.attributedText = attributedText
    }

    
    fileprivate func setupActionButtons() {
        self.stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 120),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 4),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            bookmarkButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
                       bookmarkButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
