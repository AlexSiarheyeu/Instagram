//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/30/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    //MARK: - Properties

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
        
        guard let image = selectedImage else {
            return
        }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
            
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
           
            if let error = error {
                print(error)
                return
            }
            
        Storage.storage().reference().child("posts").child(filename).downloadURL { (url, error) in
                
            if let error = error {
                print(error)
                return
            }
                    
            guard let imageUrl = url?.absoluteString else { return }
                  
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            }
         }
      }

    //MARK: Private methods
    
     func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl,
                      "caption": caption,
                      "imageWidth": postImage.size.width,
                      "imageHeight": postImage.size.height,
                      "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB \(error)")
                return
            }
            self.dismiss(animated: true)
        }
    }

    
     func setupImageAndTextViews() {
        
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

