//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/3/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var posts: Post? {
        didSet {

            guard let imageUrl = posts?.imageUrl else { return }

            userPhoto.loadImage(urlString: imageUrl)
            guard let url = URL(string: imageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Failed to fetch post image", error)
                    return
                }
                
                if url.absoluteString != self.posts?.imageUrl {
                    return
                }
                
                guard let imageData = data else { return }
                
                let photoImage = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.userPhoto.image = photoImage
                }
                
            }.resume()
        }
    }
    let userPhoto: CustomImageView = {
        let photo = CustomImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userPhoto)
        
        NSLayoutConstraint.activate ([
            userPhoto.widthAnchor.constraint(equalTo: self.widthAnchor),
            userPhoto.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
