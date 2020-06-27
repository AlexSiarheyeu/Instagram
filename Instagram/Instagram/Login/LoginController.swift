//
//  LoginController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/27/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: Properties
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    //MARK: Action methods for selectors
    @objc func handleShowSignUp() {
        self.navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
}
