//
//  UserSearchCell.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/8/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            
            guard let userImage = user?.photoImageUrl else { return }
            
            usernameLabel.text = user?.username
            userImageView.loadImage(urlString: userImage)
        }
    }
    
    let userImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        addSubview(userImageView)
        addSubview(usernameLabel)
        userImageView.layer.cornerRadius = 50/2
        
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            usernameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 8)
        ])
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
