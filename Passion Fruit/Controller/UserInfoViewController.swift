//
//  UserInfoViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-08.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserInfoViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ethnicityTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var preferenceTextField: UITextField!
    @IBOutlet weak var lookingTextField: UITextField!
    @IBOutlet weak var intoTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var likeTextField: UITextField!
    @IBOutlet weak var expectTextField: UITextField!
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Functions
    
    // Save Profile Info
    func saveProfileInfo() {
        if Auth.auth().currentUser != nil {
            // User signed in
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
            let userInfoReference = databaseReference.child("users").child(uid!).child("user_info") // : https://passion-fruit-39bda.firebaseio.com/users/uid/user_info
            userInfoReference.child("/user_name").setValue(userNameTextField.text)
            userInfoReference.child("/age").setValue(ageTextField.text)
            userInfoReference.child("/ethnicity").setValue(ethnicityTextField.text)
            userInfoReference.child("/height").setValue(heightTextField.text)
            userInfoReference.child("/weight").setValue(weightTextField.text)
            userInfoReference.child("/gender").setValue(genderTextField.text)
            userInfoReference.child("/preference").setValue(preferenceTextField.text)
            userInfoReference.child("/looking_for").setValue(lookingTextField.text)
            userInfoReference.child("/into").setValue(intoTextField.text)
            userInfoReference.child("/about").setValue(aboutTextField.text)
            userInfoReference.child("/like").setValue(likeTextField.text)
            userInfoReference.child("/expect").setValue(expectTextField.text)
        }
        //performSegue(withIdentifier: "userInfoToMainTabBar", sender: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.present(mainTabBarController, animated: true, completion: nil)
        // User not signed in
    }
    
    // MARK: - IBActions
    
    @IBAction func skipBarButtonPressed(_ sender: Any) {
        saveProfileInfo()
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        saveProfileInfo()
    }
    
}
