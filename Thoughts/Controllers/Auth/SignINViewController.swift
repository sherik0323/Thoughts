//
//  SignINViewController.swift
//  Thoughts
//
//  Created by Sherozbek on 17/11/23.
//

import UIKit

class SignINViewController: UITabBarController {
    
    // Header View
    private let headerView = SignInHeaderView()
    
    // Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Email Address"
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
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
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // Create an ACcount
    private let creaetAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(creaetAccountButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        creaetAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
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
        
        emailField.frame = CGRect(x: padding,
                                  y: headerView.frame.maxY + padding,
                                  width: view.bounds.width - 2 * padding,
                                  height: textFieldHeight)
        
        passwordField.frame = CGRect(x: padding,
                                     y: emailField.frame.maxY + padding,
                                     width: view.bounds.width - 2 * padding,
                                     height: textFieldHeight)
        
        signInButton.frame = CGRect(x: padding,
                                    y: passwordField.frame.maxY + padding,
                                    width: view.bounds.width - 2 * padding,
                                    height: buttonHeight)
        
        creaetAccountButton.frame = CGRect(x: padding,
                                           y: signInButton.frame.maxY + padding,
                                           width: view.bounds.width - 2 * padding,
                                           height: buttonHeight)
    }
    
    
    
    
    @objc  func didTapSignIn() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard success else {
                return
            }
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }

        }
    }
    
    @objc  func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
