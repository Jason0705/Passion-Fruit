//
//  ProfileOptionViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-16.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class ProfileOptionViewController: UIViewController {

    
    // MMARK: - Variables
    var optionsData = [""]
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell.xib
        optionsTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
    }
    
    
}


//MARK: - Table View Delegation, Data Source

extension ProfileOptionViewController: UITableViewDelegate, UITableViewDataSource {

    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsData.count
    }

    // Populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileStatsCell", for: indexPath) as! ProfileStatsCell
        cell.titleLabel.text = optionsData[indexPath.row]
        return cell
    }

    // Select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileStatsCell {
            // if unselected
            if cell.tag == 0 {
                cell.tag = 1
                cell.accessoryType = .checkmark
            }
                // if selected
            else {
                cell.tag = 0
                cell.accessoryType = .none
            }

        }
    }


}
