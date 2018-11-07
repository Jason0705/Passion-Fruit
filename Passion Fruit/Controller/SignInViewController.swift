//
//  SignInViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - IBOtlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var toSignUpButton: UIButton!
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Textfields Customization
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.borderStyle = .none
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor.gray.cgColor
        emailTextField.layer.addSublayer(emailBottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.borderStyle = .none
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width, height: 0.6)
        passwordBottomLayer.backgroundColor = UIColor.gray.cgColor
        passwordTextField.layer.addSublayer(passwordBottomLayer)
    }
    


}
