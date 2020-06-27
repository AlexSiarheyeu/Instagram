//
//  LoginController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/27/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    //MARK: View Controller Lifecycle
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
         
         navigationController?.isNavigationBarHidden = true
         
         view.addSubview(dontHaveAccountButton)
         view.addSubview(logoContainerView)
        
         
         NSLayoutConstraint.activate([
             dontHaveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
             dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             
             logoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
             logoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
             logoContainerView.topAnchor.constraint(equalTo: view.topAnchor)
         ])
         
         setupUserLogInView()
     }
    
    //MARK: Properties
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
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        //button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        return view
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    //MARK: Action methods for selectors
    @objc func handleShowSignUp() {
        self.navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
                          passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            logInButton.isEnabled = true
            logInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            logInButton.isEnabled = false
            logInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
//    @objc func handleLogin() {
//
//    }
    //MARK: - Private methods
    
    func setupUserLogInView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, logInButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 20),
            stackView.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
}
