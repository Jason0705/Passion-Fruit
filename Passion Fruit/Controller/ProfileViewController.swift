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
    
    var from = 0 // from tab controll, 1: from profile selection
    var otherUID = String()
    
    var uid = String()
    
//    var profilePhotoURL: String?
//    var userName: String?
//    var age: String?
    var user = User()
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register xib
        profileCollectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        
        profileCollectionView.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postCollectionCell")
        
        
        setUp()
        
        FetchUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(4, forKey: "SelectedTabBar")
    }
    
//    override func viewWillLayoutSubviews() {
//        super .viewWillLayoutSubviews()
//        profileCollectionView.collectionViewLayout.invalidateLayout()
//    }
    
    
    
    // MARK: - Functions
    
    func setUp() {
        if from == 0 { // from tab control, self profile
            self.navigationItem.rightBarButtonItem = menuBarButton
        }
        else if from == 1 { // from profile selection, other's profile
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func FetchUser() {
        if from == 0 { // from tab control, self profile
            uid = UserService.getCurrentUserID()
        }
        else if from == 1 { // from profile selection, other's profile
            uid = otherUID
        }
        
//        user = UserService.getUser(with: uid)
        
        UserService.getUser(with: uid) { (user, error) in
            if error != nil {
                print(error!)
            }
            
//            self.profilePhotoURL = user?.profile_photo_url
//            self.userName = user?.user_name
//            if user?.age != nil {
//                self.age = user?.age!["content"] as? String
//            }
            
            if user != nil {
                self.user = user!
                
                
                self.profileCollectionView.reloadData()
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    // MARK: - IBActions
    
//    @IBAction func editButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "profileToProfileEditVC", sender: nil)
//    }
    
    
    
    @IBAction func menuBarButtonPressed(_ sender: UIBarButtonItem) {
        profileCollectionView.reloadData()
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



// MARK: - UICollectionView Delegate & Data Source

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // Cells
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionCell
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    // Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            
            if from == 0 { // from tab control, self profile
                headerView.editProfileButton.isHidden = false
                headerView.FollowMessageButtonsStackView.isHidden = true
            }
            else if from == 1 { // from profile selection, other's profile
                headerView.editProfileButton.isHidden = true
                headerView.FollowMessageButtonsStackView.isHidden = false
            }

//            if let url = profilePhotoURL {
//                headerView.profileImageView.image = ImageService().getImageUsingCacheWithURL(urlString: url)
//            }
//            if let userName = self.userName {
//                headerView.userNameLabel.text = userName
//            }
            
            if let age = user.age, age["content"] as? String != "" {
                headerView.moreButton.isHidden = false
            }
//            else {
//                headerView.moreButton.isHidden = true
//            }
            
            
            if let url = user.profile_photo_url {
                headerView.profileImageView.image = ImageService().getImageUsingCacheWithURL(urlString: url)
            }
            if let userName = user.user_name {
                headerView.userNameLabel.text = userName
            }
            
            
            headerView.backgroundColor = UIColor.blue
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
//        if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? ProfileHeaderView {
//
//            headerView.layoutIfNeeded()
//
//            let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//
//            return CGSize(width: collectionView.frame.width, height: height)
//        }
        
        
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView", for: IndexPath(row: 0, section: section)) as? ProfileHeaderView {
            
            headerView.layoutIfNeeded()
            
            return CGSize(width: collectionView.frame.width, height: headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
        }
        
        return CGSize(width: collectionView.frame.width, height: 1)
    }
    

}
