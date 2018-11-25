//
//  NewPostViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-23.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var newPostTableView: UITableView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = StaticVariables.tabBarSelected
    }
    @IBAction func shareBarButtonPressed(_ sender: Any) {
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
}

