//
//  SignUpViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        confirmPasswordTextField.backgroundColor = UIColor.clear
        confirmPasswordTextField.borderStyle = .none
        let confirmPasswordBottomLayer = CALayer()
        confirmPasswordBottomLayer.frame = CGRect(x: 0, y: confirmPasswordTextField.frame.height - 1, width: confirmPasswordTextField.frame.width, height: 0.6)
        confirmPasswordBottomLayer.backgroundColor = UIColor.gray.cgColor
        confirmPasswordTextField.layer.addSublayer(confirmPasswordBottomLayer)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: "test1@gmail.com", password: "123456") { (user, error) in
            if error != nil {
                print("User Creation Error: \(error?.localizedDescription)")
                return
            }
            print(user)
        }
    }
    
    @IBAction func toSignInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
