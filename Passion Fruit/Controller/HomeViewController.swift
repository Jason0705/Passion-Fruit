//
//  HomeViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-13.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(0, forKey: "SelectedTabBar")
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
