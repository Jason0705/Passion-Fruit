//
//  ProfileOptionViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-16.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class ProfileOptionViewController: UIViewController {

    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

}


// MARK: - Table View Delegation, Data Source

extension ProfileOptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
