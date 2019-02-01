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
import FirebaseDatabase


class ProfileViewController: UIViewController {

    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    
    var from = 0 // from tab controll, 1: from profile selection
    var uid: String!
    var user = User()
    
    // for header
    var headerIndexPath = IndexPath()
    var moreButtonTag = 0
    var publicPrivateSegmentedControlSelectedIndex = 0
    
    // for cells
    var publicPosts = [Post]()
    var privatePosts = [Post]()
    
    
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
        
        fetchUser()
        fetchPosts(of: "public")
        fetchPosts(of: "private")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(4, forKey: "SelectedTabBar")
    }
    
    
    
    // MARK: - Functions
    
    func setUp() {
        if from == 0 { // from tab control, self profile
            self.navigationItem.rightBarButtonItem = menuBarButton
        }
        else if from == 1 { // from profile selection, other's profile
            self.navigationItem.rightBarButtonItem = nil
        }
        
        profileCollectionView.collectionViewLayout = CustomizationService.threeCellPerRowStyle(view: self.view, lineSpacing: 2, itemSpacing: 1, inset: 0, heightMultiplier: 1)
    }
    
    
    func fetchUser() {
        if from == 0 { // from tab control, self profile
            uid = UserService.getCurrentUserID()
        }
        
        UserService.getUser(with: uid) { (user, error) in
            if error != nil {
                print(error!)
            }
            
            else if user != nil {
                self.user = user!
                
                self.profileCollectionView.reloadData()
            }
            
        }
        
    }
    
    
    func fetchPosts(of kind: String) {
        if from == 0 { // from tab control, self profile
            uid = UserService.getCurrentUserID()
        }
        
        PostService.fetchPosts(of: kind, with: uid) { (posts, error) in
            if error != nil {
                print(error!)
            }
            else if posts != nil {
                if kind == "public" {
                    self.publicPosts = posts!
                }
                else if kind == "private" {
                    self.privatePosts = posts!
                }
                
                self.profileCollectionView.reloadData()
            }
        }
    }
    
    
    
    
    
    // MARK: - IBActions
    
    
    @IBAction func menuBarButtonPressed(_ sender: UIBarButtonItem) {
//        profileCollectionView.reloadData()
        if sender.tag == 0 {
            sender.tag = 1
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.view.superview?.superview?.bounds.origin.x = 0 + 240
                self.view.layoutIfNeeded()
            }
        }
        else if sender.tag == 1 {
            sender.tag = 0
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.view.superview?.superview?.bounds.origin.x = 0
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
        
        switch publicPrivateSegmentedControlSelectedIndex {
        case 0:
            return publicPosts.count
        case 1:
            return privatePosts.count
        default:
            return publicPosts.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionCell
        cell.backgroundColor = UIColor.green
        
        func showImage() {
            cell.postImageContainerView.isHidden = false
            cell.postVideoContainerView.isHidden = true
        }
        func showVideo() {
            cell.postImageContainerView.isHidden = true
            cell.postImageView.image = nil
            cell.postVideoContainerView.isHidden = false
        }
        
        switch publicPrivateSegmentedControlSelectedIndex {
        case 0: // public posts
            let post = publicPosts[indexPath.row]
            if let postImageURL = post.image_url {
                showImage()
                cell.postImageView.image = ImageService.getImageUsingCacheWithURL(urlString: postImageURL)
            }
            else {
                showVideo()
            }
            if let postVideoURL = post.video_url {
                showVideo()
                let player = VideoService.getPlayerUsingCacheWithURL(urlString: postVideoURL)
                VideoService.createAVPlayerLayer(on: cell.postVideoView, with: player, play: false)
            }
            else {
                showImage()
            }
        case 1: // private posts
            let post = privatePosts[indexPath.row]
            if let postImageURL = post.image_url {
                showImage()
                cell.postImageView.image = ImageService.getImageUsingCacheWithURL(urlString: postImageURL)
            }
            else {
                showVideo()
            }
            if let postVideoURL = post.video_url {
                showVideo()
                let player = VideoService.getPlayerUsingCacheWithURL(urlString: postVideoURL)
                VideoService.createAVPlayerLayer(on: cell.postVideoView, with: player, play: false)
            }
            else {
                showImage()
            }
        default:
            break
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let a = publicPosts[indexPath.row]
        print("!!!!\(a.image_url)")
        
    }
    
    
    // Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            
            var labelOrigin = CGPoint(x: 0, y: 0)
            var labelViewHeight: CGFloat = 0
            
            func createLabelView(title: String, body: String, in view: UIView, at origin: CGPoint) {
                let labelView = UIView()
                labelView.frame = CGRect(x: 0, y: origin.y, width: headerView.frame.width - 48, height: 30)
                let height = labelView.createProfileLabelWithTitle(title: title, body: body)
                labelView.frame = CGRect(x: 0, y: origin.y, width: headerView.frame.width - 48, height: height)
                labelView.addUnderline()
                view.addSubview(labelView)
                labelOrigin.y += labelView.bounds.height + 16
                labelViewHeight += labelView.bounds.height + 16
            }
            
            headerView.delegate = self
            
            headerIndexPath = indexPath
            headerView.moreButton.tag = moreButtonTag
            headerView.moreButton.setTitle("", for: .normal)
            headerView.publicPrivateSegmentedControl.selectedSegmentIndex = publicPrivateSegmentedControlSelectedIndex
            
            
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
            }
            
            if moreButtonTag == 0 {
                headerView.moreButton.setImage(UIImage(named: "round_expand_more"), for: .normal)
                headerView.infoLabelView.isHidden = true
            }
            else if moreButtonTag == 1 {
                headerView.moreButton.setImage(UIImage(named: "round_expand_less"), for: .normal)
                headerView.infoLabelView.isHidden = false
            }

            if let url = user.profile_photo_url {
                headerView.profileImageView.image = ImageService.getImageUsingCacheWithURL(urlString: url)
            }
            if let userName = user.user_name {
                headerView.userNameLabel.text = userName
                
            }
            
            if let iAm = user.i_am, iAm != "" {
                createLabelView(title: "I Am", body: iAm, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let iLike = user.i_like, iLike != "" {
                createLabelView(title: "I Like", body: iLike, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let myDate = user.my_date_would, myDate != "" {
                createLabelView(title: "My Date Would", body: myDate, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let age = user.age, age["content"] as? String != "" {
                createLabelView(title: "Age", body: age["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let height = user.height, height["content"] as? String != "" {
                createLabelView(title: "Height", body: height["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let weight = user.weight, weight["content"] as? String != "" {
                createLabelView(title: "Weight", body: weight["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let ethnicity = user.ethnicity, ethnicity["content"] as? String != "" {
                createLabelView(title: "Ethnicity", body: ethnicity["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let gender = user.gender, gender["content"] as? String != "" {
                createLabelView(title: "Gender", body: gender["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let interested = user.interested, interested["content"] as? String != "" {
                createLabelView(title: "Interested", body: interested["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let relationshipStatus = user.relationship_status, relationshipStatus["content"] as? String != "" {
                createLabelView(title: "Relationship Status", body: relationshipStatus["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let want = user.want, want["content"] as? String != "" {
                createLabelView(title: "Want", body: want["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            if let lookingFor = user.looking_for, lookingFor["content"] as? String != "" {
                createLabelView(title: "Looking For", body: lookingFor["content"] as! String, in: headerView.infoLabelView, at: labelOrigin)
            }
            
            headerView.infoLabelViewHeight.constant = labelViewHeight - 16

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
    
    func editProfile() {
        performSegue(withIdentifier: "profileToProfileEditVC", sender: nil)
    }
    
    func reloadCollectionViewWith(moreTag: Int) {
        
        if moreTag == 0 {
            moreButtonTag = 1
        }
        else if moreTag == 1 {
            moreButtonTag = 0
        }
        profileCollectionView.reloadData()

    }
    
    func reloadCollectionViewWith(segmentIndex: Int) {
        if segmentIndex == 0 {
            publicPrivateSegmentedControlSelectedIndex = 0
        }
        else if segmentIndex == 1 {
            publicPrivateSegmentedControlSelectedIndex = 1
        }
        profileCollectionView.reloadData()
    }


}
