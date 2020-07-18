//
//  ViewController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/22/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(plusPhotoButton)
        
        setupInputTextFields()
        
        NSLayoutConstraint.activate([
            alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //fileprivate methods call
        setupInputTextFields()
     }
    
    //MARK: - Properties
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        email.backgroundColor = UIColor(white: 0, alpha: 0.03)
        email.borderStyle = .roundedRect
        email.font = UIFont.systemFont(ofSize: 14)
        
        email.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return email
    }()
    
    let usernameTextField: UITextField = {
        let username = UITextField()
        username.placeholder = "Username"
        username.translatesAutoresizingMaskIntoConstraints = false
        username.backgroundColor = UIColor(white: 0, alpha: 0.03)
        username.borderStyle = .roundedRect
        username.font = UIFont.systemFont(ofSize: 14)
        
        username.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return username
        
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = UIColor(white: 0, alpha: 0.03)
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 14)
        password.isSecureTextEntry = true
        
        password.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return password
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Action methods for selectors
    
    @available(iOS 13.0, *)
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = usernameTextField.text, username.count > 0 else {
                
              return
        }
        
        Auth.auth().createUser(withEmail: email, password: password)
            { (user, error) in
            if let error = error {
                print (error)
                return
            }
                
            guard let image  = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
                
                  let fileName = NSUUID().uuidString
                  let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
                    
                  storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
            if let error = error {
                    print (error)
                    return
            }
                    storageRef.downloadURL { (url, error) in
                        
            if let error = error {
                    print(error)
                    return
            } else {
                    storageRef.downloadURL { (url, error) in

            guard let uid = user?.user.uid  else { return }
            guard let photo = url?.absoluteString else { return }
                        
                  let usernameValues = ["username": username, "email": email, "photo": photo]
                  let values = [uid: usernameValues]
         
         Database.database().reference().child("users").updateChildValues(values)
            { (error, ref) in
                
            if let error = error {
                    print (error)
                    return
            }
                    guard let mainVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                               
                    mainVC.setupViewControllers()
                               
                    self.dismiss(animated: true)
                
            }
           }
          }
         }
        }
       }
      }


    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
                          usernameTextField.text?.count ?? 0 > 0 &&
                          passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)

        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
        
    }
    

    //MARK: - Setup User Interface
    
    fileprivate func setupInputTextFields() {
        
        //create Stack View
        let stackView = UIStackView(arrangedSubviews:
            [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        //setup constraints
        NSLayoutConstraint.activate([
            
           stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
           stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
           stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
           stackView.heightAnchor.constraint(equalToConstant: 200),
           
           plusPhotoButton.widthAnchor.constraint(equalToConstant: 140),
           plusPhotoButton.heightAnchor.constraint(equalToConstant: 140),
           plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
        ])
    }
}


