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
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register xib
        profileCollectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        
        profileCollectionView.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postCollectionCell")
        
        
        profileCollectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(4, forKey: "SelectedTabBar")
    }
    
    
    
    
    // MARK: - IBActions
    
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



// MARK: - UICollectionView Delegate & Data Source

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            
            header.backgroundColor = UIColor.blue
            return header
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 378)
    }
    

}
