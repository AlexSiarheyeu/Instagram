//
//  ViewController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/22/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    //MARK: - Properties
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    //MARK: - Action methods for selectors
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, username.count > 0 else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return
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
    
    //MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        
        setupInputTextFields()
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


