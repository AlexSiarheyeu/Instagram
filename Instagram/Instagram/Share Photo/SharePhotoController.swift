//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/30/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
        
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    //MARK: - Action methods for selectors
    
    @objc func handleShare() {
        
    }
    
    //MARK: Private methods
    
    fileprivate func setupImageAndTextViews() {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
       
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 10),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -10),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
    }
}
