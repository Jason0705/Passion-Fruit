//
//  SignInViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

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
        textFieldsUnderline()
        
        // State Preperation
        signInButton.isEnabled = false
        
        checkTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoSignIn()
    }
    
    
    // MARK: - Functions
    
    // Text Fields Underline style
    func textFieldsUnderline() {
        CustomizationService.textFieldUnderline(textField: emailTextField)
        CustomizationService.textFieldUnderline(textField: passwordTextField)
    }
    
    // Auto Sign In
    func autoSignIn() {
        if Auth.auth().currentUser != nil {
//            performSegue(withIdentifier: "signInToMainTabBarController", sender: nil)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = viewController
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    // MARK: - IBActions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        view.endEditing(true)
        SVProgressHUD.show()
        
        // Sign in user using email and password input.
        AuthService.signInUser(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "signInToMainTabBarController", sender: nil)
        }, onFail: { (error) in
            SVProgressHUD.dismiss()
            AlertService.alertService.presentErrorAlert(message: error!, vc: self)
        })
    }
    
}
