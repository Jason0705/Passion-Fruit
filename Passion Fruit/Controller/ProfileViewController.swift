//
//  ProfileViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "ProfileEdit", bundle: nil)
//        let profileEditNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileEditNavigationController")
//        self.present(profileEditNavigationController, animated: true, completion: nil)
        performSegue(withIdentifier: "profileToProfileEditVC", sender: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
            
        } catch let logOutError {
            print(logOutError)
            SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
        }
        
    }
    

}
