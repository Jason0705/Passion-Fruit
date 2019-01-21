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
    var uid: String!
    var user = User()
    
    // for header
    var headerIndexPath = IndexPath()
    var infoLabelViewIsHidden = true
    var moreButtonTag = 0
    
    
    
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
        
        FetchCurrentUser()
        
        profileCollectionView.reloadData()
        
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
        
        profileCollectionView.collectionViewLayout = CustomizationService.threeCellPerRowStyle(view: self.view, lineSpacing: 1, itemSpacing: 1, inset: 0, heightMultiplier: 1)
    }
    
    func FetchCurrentUser() {
        if from == 0 { // from tab control, self profile
            uid = UserService.getCurrentUserID()
        }
        
        UserService.getUser(with: uid) { (user, error) in
            if error != nil {
                print(error!)
            }
            
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionCell
        cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    // Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            
            headerView.delegate = self
            
            headerIndexPath = indexPath
            headerView.moreButton.tag = moreButtonTag
            
            headerView.infoLabelView.isHidden = infoLabelViewIsHidden
            
            if from == 0 { // from tab control, self profile
                headerView.editProfileButton.isHidden = false
                headerView.FollowMessageButtonsStackView.isHidden = true
            }
            else if from == 1 { // from profile selection, other's profile
                headerView.editProfileButton.isHidden = true
                headerView.FollowMessageButtonsStackView.isHidden = false
            }

            if let iAm = user.i_am, let iLike = user.i_like, let myDate = user.my_date_would, let age = user.age, let height = user.height, let weight = user.weight, let ethnicity = user.ethnicity, let relationshipStatus = user.relationship_status, let want = user.want, let lookingFor = user.looking_for, let gender = user.gender, let interested = user.interested {

                if iAm == "" && iLike == "" && myDate == "" && age["content"] as? String == "" && height["content"] as? String == "" && weight["content"] as? String == "" && ethnicity["content"] as? String == "" && relationshipStatus["content"] as? String == "" && want["content"] as? String == "" && lookingFor["content"] as? String == "" && gender["content"] as? String == "" && interested["content"] as? String == "" {
                    headerView.moreButton.isHidden = true
                }
//                else {
//                    headerView.moreButton.isHidden = false
//                }
            }

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

        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView", for: headerIndexPath) as? ProfileHeaderView {
            
            let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height

            return CGSize(width: collectionView.frame.width, height: height)
        }

        return CGSize(width: collectionView.frame.width, height: 1)
    }
    

}


extension ProfileViewController: ProfileHeaderViewProtocol {
    
    
    func reloadCollectionView(with tag: Int) {
        
        if tag == 0 {
            moreButtonTag = 1
            infoLabelViewIsHidden = false
        }
        else if tag == 1 {
            moreButtonTag = 0
            infoLabelViewIsHidden = true
        }
        profileCollectionView.reloadData()

    }


}
