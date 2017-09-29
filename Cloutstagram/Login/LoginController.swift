//
//  LoginController.swift
//  Cloutstagram
//
//  Created by sana on 2017-09-29.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dont't have an account? Sign Up.", for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
    }()
    
    // Swaps to Sign Up page
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    // Onload ..
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back navigation bar
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
}
