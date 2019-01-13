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

    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(4, forKey: "SelectedTabBar")
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "profileToProfileEditVC", sender: nil)
    }
    
    
    
    @IBAction func menuBarButtonPressed(_ sender: UIBarButtonItem) {
        
        if sender.tag == 0 {
            sender.tag = 1
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.view.superview?.frame.origin.x = 0 - 240
                self.view.layoutIfNeeded()
            }
            
        }
        else if sender.tag == 1 {
            sender.tag = 0
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.view.superview?.frame.origin.x = 0
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
}
