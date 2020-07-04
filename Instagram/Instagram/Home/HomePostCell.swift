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
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
