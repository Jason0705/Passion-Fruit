//
//  SignInViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        
        // State Preperation
        signInButton.isEnabled = false
        
        checkTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoSignIn()
    }
    
    // Sign In User
    func signInUser() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
            if error != nil {
                self.presentAlert(message: "\(error!.localizedDescription)")
            }
            else {
                self.performSegue(withIdentifier: "signInToMainTabbarVC", sender: nil)
            }
        }
    }
    
    // Auto Sign In
    func autoSignIn() {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "signInToMainTabbarVC", sender: nil)
        }
    }
    
    // Checking Text Fields Format
    func checkTextFields() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.isEnabled = false
            return
        }
        signInButton.isEnabled = true
    }
    
    // Present Alert
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (AlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    // MARK: - IBActions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        // Sign in user using email and password input.
        signInUser()
    }
    
}
