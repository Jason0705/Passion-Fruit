//
//  NearByViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseAuth
import FirebaseDatabase

class NearByViewController: UIViewController {

    // MARK: - Variables
    let defaults = UserDefaults.standard
    
//    var mode: Int! {
//        // 0: Do Not Show, 1: Relationship, 2: Fun, 3: Both
//        didSet {
//            changeView()
//            print("\(mode)")
//        }
//    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var defaultView: UIView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var modeImageView: UIImageView!
    
    @IBOutlet weak var relationshipFunSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var relationshipView: UIView!
    @IBOutlet weak var relationshipViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var funView: UIView!
    @IBOutlet weak var funViewWidth: NSLayoutConstraint!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.set(1, forKey: "SelectedTabBar")
        
        // UI set up
        setUp()
        
        
        getMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    // MARK: - Functions
    
    func setUp() {
        relationshipView.backgroundColor = FlatWhite()
        funView.backgroundColor = FlatBlack()
        showRelationshipView()
    }
    
    
    func showRelationshipView() {
        relationshipViewWidth.constant = self.view.frame.width
        funViewWidth.constant = 0
        relationshipFunSegmentedControl.selectedSegmentIndex = 0
    }
    
    func showFunView() {
        relationshipViewWidth.constant = 0
        funViewWidth.constant = self.view.frame.width
        relationshipFunSegmentedControl.selectedSegmentIndex = 1
    }
    
    func getMode() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uid!).child("profile").child("user_stats").child("want_to").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any], let mode = dictionary["row"] as? Int {
                if mode == 0 {
                    self.changeView(to: 0)
                }
                else if mode == 1 {
                    self.changeView(to: 1)
                }
                else if mode == 2 {
                    self.changeView(to: 2)
                }
                else if mode == 3 {
                    self.changeView(to: 3)
                }
            }
            
        }, withCancel: nil)
        
    }
    
    func changeView(to mode: Int) {
        if mode == 0 { // Do Not Show
            defaultView.isHidden = true
            messageView.isHidden = false
        }
        else if mode == 1 { // Relationship
            defaultView.isHidden = true
            messageView.isHidden = true
            modeView.isHidden = false
            relationshipFunSegmentedControl.isHidden = true
            modeImageView.backgroundColor = UIColor.white
            showRelationshipView()
        }
        else if mode == 2 { // Fun
            defaultView.isHidden = true
            messageView.isHidden = true
            modeView.isHidden = false
            relationshipFunSegmentedControl.isHidden = true
            modeImageView.backgroundColor = UIColor.black
            showFunView()
        }
        else if mode == 3 { // Both
            defaultView.isHidden = true
            messageView.isHidden = true
            modeView.isHidden = true
            relationshipFunSegmentedControl.isHidden = false
            showRelationshipView()
        }
    }
    
    
    
    
    
    func updateProfileWant(content: String, row: Int) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let databaseReference = Database.database().reference()
        
        let userReference = databaseReference.child("users").child(uid!)
        
        userReference.child("/profile").child("/user_stats").child("want_to").child("content").setValue(content)
        userReference.child("/profile").child("/user_stats").child("want_to").child("row").setValue(row)
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func relationshipFunSegmentedControlSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.25) {
                self.showRelationshipView()
                self.view.layoutIfNeeded()
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.25) {
                self.showFunView()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func optionsButtonsPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            updateProfileWant(content: "Relationship", row: 1)
        }
        else if sender.tag == 1 {
            updateProfileWant(content: "Fun", row: 2)
        }
        else if sender.tag == 2 {
            updateProfileWant(content: "Both", row: 3)
        }
    }
    
}
