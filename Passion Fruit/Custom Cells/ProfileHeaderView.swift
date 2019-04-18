//
//  ProfileHeaderView.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-01-14.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit


protocol ProfileHeaderViewProtocol {
    func editProfile()
    func followAction()
    func unfollowAction()
    func reloadCollectionViewWith(moreTag: Int)
    func reloadCollectionViewWith(segmentIndex: Int)
}


class ProfileHeaderView: UICollectionReusableView {

    var delegate: ProfileHeaderViewProtocol?
    
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingStackView: UIStackView!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var FollowMessageButtonsStackView: UIStackView!
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBOutlet weak var infoLabelView: UIView!
    @IBOutlet weak var infoLabelViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.frame.width
        
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        delegate?.editProfile()
    }
    
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            delegate?.followAction()
//            sender.tag = 1
        }
        else if sender.tag == 1 {
            delegate?.unfollowAction()
//            sender.tag = 0
        }
    }
    
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
//            sender.tag = 1
            infoLabelView.isHidden = false
            delegate?.reloadCollectionViewWith(moreTag: 0)

        }
        else if sender.tag == 1 {
//            sender.tag = 0
            infoLabelView.isHidden = true
            delegate?.reloadCollectionViewWith(moreTag: 1)
        }
    }
    
    @IBAction func publicPrivateSegmentedControlPressed(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.reloadCollectionViewWith(segmentIndex: 0)
        case 1:
            delegate?.reloadCollectionViewWith(segmentIndex: 1)
        default:
            break
        }
        
    }
    
    
}
