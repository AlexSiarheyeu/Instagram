//
//  PreviewPhotoContainerView.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/18/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        addSubview(saveButton)
        addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            previewImageView.widthAnchor.constraint(equalTo: widthAnchor),
            previewImageView.heightAnchor.constraint(equalTo: heightAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
        ])
    }
    
    @objc func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to photo library", error)
                return
            }
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.textColor = .white
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                savedLabel.textAlignment = .center
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)

                
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                    animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                        
                }, completion: {(completed) in
                    
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.75,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                    animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: {(_) in
                        savedLabel.removeFromSuperview()
                })
            })
          }
        }
    }
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
