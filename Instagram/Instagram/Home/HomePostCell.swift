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
            
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
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
    
    @objc func handleOptionsButton() {
        print("kdsmjdks;")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        addSubview(photoImageView)
        
        addSubview(userProfileImageView)
        userProfileImageView.layer.cornerRadius = 40/2

        addSubview(usernameLabel)
        
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImageView.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            userProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor),
            
            optionsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            optionsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
