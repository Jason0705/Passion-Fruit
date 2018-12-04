//
//  NearByViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import ChameleonFramework

class NearByViewController: UIViewController {

    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var messageView: UIView!
    
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
    }
    
}
