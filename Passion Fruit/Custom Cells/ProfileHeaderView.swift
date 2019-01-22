//
//  ProfileHeaderView.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-01-14.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit


protocol ProfileHeaderViewProtocol {
    func reloadCollectionView(with tag: Int)
}


class ProfileHeaderView: UICollectionReusableView {

    var delegate: ProfileHeaderViewProtocol?
    
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var FollowMessageButtonsStackView: UIStackView!
    
    @IBOutlet weak var infoLabelView: UIView!
    @IBOutlet weak var infoLabelViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.frame.width
    }
    
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        
//        if sender.tag == 0 {
//            sender.tag = 1
//            delegate?.reloadCollectionView(with: 0)
//        }
//        else if sender.tag == 1 {
//            sender.tag = 0
//            delegate?.reloadCollectionView(with: 1)
//        }
        
        if sender.tag == 0 {
//            sender.tag = 1
            infoLabelView.isHidden = false
            delegate?.reloadCollectionView(with: 0)

        }
        else if sender.tag == 1 {
//            sender.tag = 0
            infoLabelView.isHidden = true
            delegate?.reloadCollectionView(with: 1)
        }
//
//        print("contentview Height: \(contentViewHeight.constant)")
    }
    
    
    
}
