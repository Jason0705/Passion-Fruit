//
//  SignUpViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toSignInButton: UIButton!
    
    
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
        
        confirmPasswordTextField.backgroundColor = UIColor.clear
        confirmPasswordTextField.borderStyle = .none
        let confirmPasswordBottomLayer = CALayer()
        confirmPasswordBottomLayer.frame = CGRect(x: 0, y: confirmPasswordTextField.frame.height - 1, width: confirmPasswordTextField.frame.width, height: 0.6)
        confirmPasswordBottomLayer.backgroundColor = UIColor.gray.cgColor
        confirmPasswordTextField.layer.addSublayer(confirmPasswordBottomLayer)
        
        // State Preperation
        signUpButton.isEnabled = false
        
        checkTextFields()
    }
    
    // Checking Text Fields Format
    func checkTextFields() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            signUpButton.isEnabled = false
            return
        }
        signUpButton.isEnabled = true
    }
    
    
    // MARK: - IBActions
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        // Sign up user using email and password input.
        if passwordTextField.text != confirmPasswordTextField.text {
            AlertService.alertService.presentAlert(message: "Password does not match the confirm password! Please check again.", vc: self)
            return
        }
        AuthService.signUpUser(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signUpToSetUpNavigationVC", sender: nil)
        }, onFail: { (error) in
            AlertService.alertService.presentAlert(message: error!, vc: self)
        })
    }
    
    @IBAction func toSignInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
