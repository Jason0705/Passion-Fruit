//
//  HomeViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-13.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        StaticVariables.tabBarSelected = 0
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
