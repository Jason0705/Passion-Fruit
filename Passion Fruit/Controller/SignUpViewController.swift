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
    
    // Sign Up User
    func signUpUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            guard let user = authResult?.user else { return }
            if error != nil {
                print("Sign Up Error: \(error!.localizedDescription)")
                return
            }
            let uid = user.uid
            
            self.setUserInfo(email: self.emailTextField.text!, uid: uid)
        }
    }
    
    func setUserInfo(email: String, uid: String) {
        let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
        let usersReference = databaseReference.child("users") // : https://passion-fruit-39bda.firebaseio.com/users
        let newUserReference = usersReference.child(uid) // : https://passion-fruit-39bda.firebaseio.com/users/uid
        
        newUserReference.setValue(["email": email])
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
    
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
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
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        // Sign up user using email and password input.
        if isValidEmail(email: emailTextField.text) == false {
            presentAlert(message: "The email address is badly formatted! Please check again.")
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
            presentAlert(message: "Password does not match the confirm password! Please check again.")
        }
        else {
            signUpUser()
            performSegue(withIdentifier: "signUpToSetUpNavigationVC", sender: nil)
        }
    }
    
    @IBAction func toSignInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
