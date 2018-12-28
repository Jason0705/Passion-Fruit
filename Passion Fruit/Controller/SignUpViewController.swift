//
//  SignUpViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        textFieldsUnderline()
        
        // State Preperation
        signUpButton.isEnabled = false
        
        checkTextFields()
    }
    
    
    // MARK: - Functions
    
    // Text Fields Underline Style
    func textFieldsUnderline() {
        CustomizationService.textFieldUnderline(textField: emailTextField)
        CustomizationService.textFieldUnderline(textField: passwordTextField)
        CustomizationService.textFieldUnderline(textField: confirmPasswordTextField)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToProfileEditNavigationController" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as! ProfileEditViewController
            destinationVC.from = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        
        // Sign up user using email and password input.
        if passwordTextField.text != confirmPasswordTextField.text {
            SVProgressHUD.dismiss()
            AlertService.alertService.presentErrorAlert(message: "Password does not match the confirm password! Please check again.", vc: self)
            return
        }
        AuthService.signUpUser(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "signUpToProfileEditNavigationController", sender: nil)
        }, onFail: { (error) in
            SVProgressHUD.dismiss()
            AlertService.alertService.presentErrorAlert(message: error!, vc: self)
        })
    }
    
    @IBAction func toSignInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
