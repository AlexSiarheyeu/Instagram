//
//  PhotoSelectorHeader.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/29/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    //MARK: - Properties

     let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
