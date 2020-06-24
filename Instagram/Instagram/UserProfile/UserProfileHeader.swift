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
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 12),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80)
            ])
        
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
        backgroundColor = UIColor(white: 0, alpha: 0.04)
        setupProfileImageView()
        
    }
    
    fileprivate func setupProfileImageView() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

        guard let dictionary = snapshot.value as? [String: Any] else { return }

        guard let profileImageUrl = dictionary["photo"] as? String else { return }

        guard let url = URL(string: profileImageUrl) else { return }
                   
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                       
            if let error = error {
                print ("Failed to fetch profile image,\(error)")
                return
            }
            
            guard let data = data else { return }
                
                  let image = UIImage(data: data)
                
            DispatchQueue.main.async {
                  self.profileImageView.image = image
            }
                
            }.resume()

                }) { (error) in
                print ("Failed to fetch user \(error)")
            }
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
