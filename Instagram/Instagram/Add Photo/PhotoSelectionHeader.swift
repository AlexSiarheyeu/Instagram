//
//  PhotoSelectionHeader.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/28/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class PhotoSelectionHeader: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
