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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(0, forKey: "SelectedTabBar")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func testButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
