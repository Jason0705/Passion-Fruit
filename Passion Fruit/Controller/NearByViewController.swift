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
    
    var relationshipUsers = [User]()
    var funUers = [User]()
    
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
    @IBOutlet weak var relationshipCollectionView: UICollectionView!
    
    
    @IBOutlet weak var funView: UIView!
    @IBOutlet weak var funViewWidth: NSLayoutConstraint!
    @IBOutlet weak var funCollectionView: UICollectionView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.set(1, forKey: "SelectedTabBar")
        
        // Register CustomBookCell.xib
        relationshipCollectionView.register(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        funCollectionView.register(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        
        // UI set up
        setUp()
        
        
        getCurrentUserData()
        
    }
    
    
    // MARK: - Functions
    
    func fetchUsers(gender: Int, interested: [Int]) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()

                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.i_am = dictionary["i_am"] as? String
                user.i_like = dictionary["i_like"] as? String
                user.my_date_would = dictionary["my_date_would"] as? String
                
                user.age = dictionary["age"] as? Int
                user.height = dictionary["height"] as? Int
                user.weight = dictionary["weight"] as? Int
                user.ethnicity = dictionary["ethnicity"] as? Int
                user.relationship_status = dictionary["relationship_status"] as? Int
                user.want = dictionary["want"] as? Int
                user.looking_for = dictionary["looking_for"] as? [Int]
                
                user.gender = dictionary["gender"] as? Int
                user.interested = dictionary["interested"] as? [Int]
                
                
                if user.interested == nil { // target user has no preference, assumming target user likes all gender. Query based only on current user's interested and target user's gender.
                    if interested.contains(user.gender! - 1) {
                        if user.want == 1 { // target user wants relationship
                            self.relationshipUsers.append(user)
                        }
                        else if user.want == 2 { // target user wants fun
                            self.funUers.append(user)
                        }
                        else if user.want == 3 { // target user wants both
                            self.relationshipUsers.append(user)
                            self.funUers.append(user)
                        }
                    }
                }
                else if user.interested != nil { // Target user has a preference. Query based on cross match of current user's gender and interested and target user's gender and interested.
                    if user.interested!.contains(gender - 1) && interested.contains(user.gender! - 1) {
                        if user.want == 1 { // target user wants relationship
                            self.relationshipUsers.append(user)
                        }
                        else if user.want == 2 { // target user wants fun
                            self.funUers.append(user)
                        }
                        else if user.want == 3 { // target user wants both
                            self.relationshipUsers.append(user)
                            self.funUers.append(user)
                        }
                    }
                }
                
                self.relationshipCollectionView.reloadData()
                self.funCollectionView.reloadData()
                
            }
            
            print(self.relationshipUsers)
            print("----------------")
            print(self.funUers)
//            let user = User()
//
//            user.email = snapshot.childSnapshot(forPath: "email").value as? String
//            user.uid = snapshot.childSnapshot(forPath: "uid").value as? String
//
////            user.profile.profile_photo_url = snapshot.childSnapshot(forPath: "profile/profile_photo_url").value as? String
//
//            user.profile?.profile_photo_url = "1234567890"
//
//            self.users.append(user)
//
//            print("\(user.email) || \(user.uid) || \(user.profile?.profile_photo_url)")
//
//            print("-------------------")
//            print("\(self.users[0].email)")
            
            
//            if let dictionary = snapshot.value as? [String: Any] {
//                // if dictionary... append dictionary["uid"]
//                let user = User()
////                user.setValuesForKeys(dictionary)
//                user.email = dictionary["email"] as? String
//                user.uid = dictionary["uid"] as? String
//
//                user.profile?.profile_photo_url = dictionary["profile/profile_photo_url"] as? String
////                user.profile = dictionary["profile"] as? Profile
//
//                self.users.append(user)
//
//                print("\(user.email) || \(user.uid) || \(user.profile?.profile_photo_url)")
////                print("\(dictionary)")
//            }
        }, withCancel: nil)
    }
    
    
    func fetchPhoto(from url: String) {
        
    }
    
    func setUp() {
        relationshipView.backgroundColor = FlatWhite()
        funView.backgroundColor = FlatBlack()
        showRelationshipView()
        
        relationshipCollectionView.collectionViewLayout = CustomizationService().threeCellPerRowStyle(view: relationshipView, spacing: 4, inset: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), heightMultiplier: 1)
        funCollectionView.collectionViewLayout = CustomizationService().threeCellPerRowStyle(view: relationshipView, spacing: 4, inset: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), heightMultiplier: 1)
        
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
    
    func getCurrentUserData() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any], let want = dictionary["want"] as? Int, let gender = dictionary["gender"] as? Int {
                
                self.changeView(to: want)
                
                if (dictionary["interested"] as? [Int]) != nil { // grab users based on gender and interested
                    let interested = dictionary["interested"] as? [Int]
                    
                    self.relationshipUsers.removeAll()
                    self.funUers.removeAll()
                    self.fetchUsers(gender: gender, interested: interested!)
                    
                }
                else { // grab users based on gender, assume interested in all
                    let numberOfInterestedOptions = StaticVariables.interestedData.count
                    let interested = [Int](0...numberOfInterestedOptions - 1)
                    
                    self.relationshipUsers.removeAll()
                    self.funUers.removeAll()
                    self.fetchUsers(gender: gender, interested: interested)
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
    
    
    
    
    
    func updateProfileWant(to want: Int) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let databaseReference = Database.database().reference()
        
        let userReference = databaseReference.child("users").child(uid!)
        
        userReference.child("want").setValue(want)
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
            updateProfileWant(to: 1)
        }
        else if sender.tag == 1 {
            updateProfileWant(to: 2)
        }
        else if sender.tag == 2 {
            updateProfileWant(to: 3)
        }
    }
    
}



// MARK: - Collection View Delegation, Data Source

extension NearByViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == relationshipCollectionView {
            count = relationshipUsers.count
        }
        else if collectionView == funCollectionView {
            count = funUers.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCell
        
        if collectionView == relationshipCollectionView {
            let user = relationshipUsers[indexPath.row]
            cell.userNameLabel.text = user.user_name
            
            if let profileImageURL = user.profile_photo_url {
                cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageURL)
            }
        }
        else if collectionView == funCollectionView {
            let user = funUers[indexPath.row]
            cell.userNameLabel.text = user.user_name
            
            if let profileImageURL = user.profile_photo_url {
                cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageURL)
            }
        }
        
        return cell
    }
    
    
}
