//
//  SignUpViewController.swift
//  Thoughts
//
//  Created by Sherozbek on 17/11/23.
//

import UIKit

class SignUpViewController: UITabBarController {


        
        // Header View
        private let headerView = SignInHeaderView()
    
        //Name field
            private let nameField: UITextField = {
                let field = UITextField()
                field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
                field.placeholder = "Full Name"
                field.leftViewMode = .always
                field.autocorrectionType = .no
                field.autocapitalizationType = .none
                field.backgroundColor = .secondarySystemBackground
                field.layer.cornerRadius = 8
                field.layer.masksToBounds = true
                return field
            }()
        
        // Email field
        private let emailField: UITextField = {
            let field = UITextField()
            field.keyboardType = .emailAddress
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            field.placeholder = "Email Address"
            field.leftViewMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.backgroundColor = .secondarySystemBackground
            field.layer.cornerRadius = 8
            field.layer.masksToBounds = true
            return field
        }()
        
        //Password Field
        private let passwordField: UITextField = {
            let field = UITextField()
            field.keyboardType = .emailAddress
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            field.leftViewMode = .always
            field.placeholder = "Password"
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.isSecureTextEntry = true
            field.backgroundColor = .secondarySystemBackground
            field.layer.cornerRadius = 8
            field.layer.masksToBounds = true
            return field
        }()
        
        //Sign In Button
        private let signUpButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .systemGreen
            button.setTitle("Create Account", for: .normal)
            button.setTitleColor(.white, for: .normal)
            return button
        }()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Create Account"
            view.backgroundColor = .systemBackground
            view.addSubview(headerView)
            view.addSubview(nameField)
            view.addSubview(emailField)
            view.addSubview(passwordField)
            view.addSubview(signUpButton)
            
            
            
            signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
            
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            let headerViewWidth: CGFloat = 200
            headerView.frame = CGRect(x: (view.bounds.width - headerViewWidth) / 2,
                                      y: view.safeAreaInsets.top,
                                      width: headerViewWidth,
                                      height: 200)
            
            let padding: CGFloat = 20
            let textFieldHeight: CGFloat = 40
            let buttonHeight: CGFloat = 40
            
            nameField.frame = CGRect(x: padding,
                                      y: headerView.frame.maxY + padding,
                                      width: view.bounds.width - 2 * padding,
                                      height: textFieldHeight)
            
            emailField.frame = CGRect(x: padding,
                                      y: nameField.frame.maxY + padding,
                                      width: view.bounds.width - 2 * padding,
                                      height: textFieldHeight)
            
            passwordField.frame = CGRect(x: padding,
                                         y: emailField.frame.maxY + padding,
                                         width: view.bounds.width - 2 * padding,
                                         height: textFieldHeight)
            
            signUpButton.frame = CGRect(x: padding,
                                        y: passwordField.frame.maxY + padding,
                                        width: view.bounds.width - 2 * padding,
                                        height: buttonHeight)
            
            
        }
        
        
        
        
        @objc  func didTapSignUp() {
            guard let email = emailField.text, !email.isEmpty,
                  let password = passwordField.text, !password.isEmpty,
                  let name = nameField.text, !name.isEmpty else {
                return
            }
            
            AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
                if success {
                    let newUser = User(name: name, email: email, profilePictureRef: nil)
                    DataBaseManager.shared.insertUser(user: newUser) { inserted in
                        guard inserted else {
                            return
                        }
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        DispatchQueue.main.async {
                            let vc = TabBarViewController()
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc, animated: true)
                        }
                    }
                } else {
                    print("Failed to create an account")
                }
            }
        }
    
            
        
     

    

}
