//
//  SocialViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-01.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController {

    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.set(3, forKey: "SelectedTabBar")
        
    }
    

}
