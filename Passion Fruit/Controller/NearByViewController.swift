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
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var defaultView: UIView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var modeImageView: UIImageView!
    
    @IBOutlet weak var relationshipFunSegmentedControl: UISegmentedControl!
    
   
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.set(1, forKey: "SelectedTabBar")
        
        // Register CustomBookCell.xib
        usersCollectionView.register(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        
        // UI set up
        setUp()
        
        
        fetchCurrentUserData()
        
    }
    
    
    
    // MARK: - Functions
    
    func fetchCurrentUserData() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uid!).observe(.value , with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any], let want = dictionary["want"] as? [String: Any], let wantChoice = want["choice"] as? Int, let gender = dictionary["gender"] as? [String: Any], let genderChoice = gender["choice"] as? Int {
                
                self.changeView(to: wantChoice)
                
                
                if dictionary["interested"] as? [String: Any] != nil { // grab users based on gender and interested
                    let interested = dictionary["interested"]as? [String: Any]
                    let interestedChoice = interested!["choice"] as? [Int]
                    self.fetchUsers(gender: genderChoice, interested: interestedChoice!)

                }
                else { // grab users based on gender, assume interested in all
                    let numberOfInterestedOptions = StaticVariables.interestedData.count
                    let interestedChoice = [Int](0...numberOfInterestedOptions - 1)
                    
                    self.fetchUsers(gender: genderChoice, interested: interestedChoice)
                }
            }
            
        }, withCancel: nil)
        
    }
    
    
    
    func fetchUsers(gender: Int, interested: [Int]) {

        relationshipUsers.removeAll()
        funUers.removeAll()

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

                user.age = dictionary["age"] as? [String: Any]
                user.height = dictionary["height"] as? [String: Any]
                user.weight = dictionary["weight"] as? [String: Any]
                user.ethnicity = dictionary["ethnicity"] as? [String: Any]
                user.relationship_status = dictionary["relationship_status"] as? [String: Any]
                user.want = dictionary["want"] as? [String: Any]
                user.looking_for = dictionary["looking_for"] as? [String: Any]

                user.gender = dictionary["gender"] as? [String: Any]
                user.interested = dictionary["interested"] as? [String: Any]

                if user.interested == nil && user.gender != nil { // target user has no preference, assumming target user likes all gender. Query based only on current user's interested and target user's gender.
                    if let userGenderChoice = user.gender!["choice"] as? Int, let userWantChoice = user.want!["choice"] as? Int {
                        if interested.contains(userGenderChoice - 1) {
                            if userWantChoice == 1 { // target user wants relationship
                                self.relationshipUsers.append(user)
                            }
                            else if userWantChoice == 2 { // target user wants fun
                                self.funUers.append(user)
                            }
                            else if userWantChoice == 3 { // target user wants both
                                self.relationshipUsers.append(user)
                                self.funUers.append(user)
                            }
                            
                        }
                    }
                    
                }
                else if user.interested != nil && user.gender != nil { // Target user has a preference. Query based on cross match of current user's gender and interested and target user's gender and interested.
                    if let userInterestedChoice = user.interested!["choice"] as? [Int], let userGenderChoice = user.gender!["choice"] as? Int, let userWantChoice = user.want!["choice"] as? Int {
                        
                        if interested.contains(userGenderChoice - 1) && userInterestedChoice.contains(gender - 1) {
                            if userWantChoice == 1 { // target user wants relationship
                                self.relationshipUsers.append(user)
                                
                                print("Self: \(interested) || \(gender)")
                                print("Relationship: \(user.user_name) || \(user.gender) || \(user.interested)")
                            }
                            else if userWantChoice == 2 { // target user wants fun
                                self.funUers.append(user)
                                
                                print("Self: \(interested) || \(gender)")
                                print("Fun: \(user.user_name) || \(user.gender) || \(user.interested)")
                            }
                            else if userWantChoice == 3 { // target user wants both
                                self.relationshipUsers.append(user)
                                self.funUers.append(user)
                                
                                print("Self: \(interested) || \(gender)")
                                print("Both: \(user.user_name) || \(user.gender) || \(user.interested)")
                            }
                            
                        }
                        
                    }
                }

                print("Relationship count: \(self.relationshipUsers.count) || Fun count: \(self.funUers.count)")
                print("----------------\n")

                self.usersCollectionView.reloadData()
                self.usersCollectionView.collectionViewLayout.invalidateLayout()

            }
        }, withCancel: nil)
    }
    
    
    
    func setUp() {
        showRelationshipView()
        
        usersCollectionView.collectionViewLayout = CustomizationService().threeCellPerRowStyle(view: self.view, spacing: 4, inset: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), heightMultiplier: 1)
    }
    
    
    func showRelationshipView() {
        usersCollectionView.backgroundColor = FlatWhite()
        relationshipFunSegmentedControl.selectedSegmentIndex = 0
        
        usersCollectionView.reloadData()
        usersCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func showFunView() {
        usersCollectionView.backgroundColor = FlatBlack()
        relationshipFunSegmentedControl.selectedSegmentIndex = 1
        
        usersCollectionView.reloadData()
        usersCollectionView.collectionViewLayout.invalidateLayout()
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
            showRelationshipView()
        }
        else if sender.selectedSegmentIndex == 1 {
            showFunView()
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
        switch relationshipFunSegmentedControl.selectedSegmentIndex {
        case 0:
            return relationshipUsers.count
        case 1:
            return funUers.count
        default:
            return relationshipUsers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCell
        
        switch relationshipFunSegmentedControl.selectedSegmentIndex {
        case 0:
            let user = relationshipUsers[indexPath.row]
            cell.userNameLabel.text = user.user_name
            
            if let profileImageURL = user.profile_photo_url {
                cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageURL)
            }

        case 1:
            let user = funUers[indexPath.row]
            cell.userNameLabel.text = user.user_name
            
            if let profileImageURL = user.profile_photo_url {
                cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageURL)
            }

        default:
            break
        }
        
        return cell
    }
    
    
    
}


