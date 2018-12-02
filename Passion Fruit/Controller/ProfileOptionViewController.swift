//
//  ProfileOptionViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-16.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit


protocol ProfileOptionReceive {
    func optionReceived(option: String, lastSelected: [Int])
    func updateSection(section: Int)
}


class ProfileOptionViewController: UIViewController {

    
    // MMARK: - Variables
    
    var delegate: ProfileOptionReceive?
    
    var optionsData = [String]()
    var fromSection = Int()
    
    var lastSelected = [Int]()
    var selectedOptionsArray = [String]()
    var selectedOptions = ""
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell.xib
        optionsTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            saveSelectedOptions()
            selectedOptions = selectedOptionsArray.joined(separator: ", ")
            delegate?.optionReceived(option: selectedOptions, lastSelected: lastSelected)
            if fromSection == 2 {
                delegate?.updateSection(section: 2)
            }
            else if fromSection == 3 {
                delegate?.updateSection(section: 3)
            }
        }
    }
    
    func saveSelectedOptions() {
        lastSelected.removeAll()
        for index in 0...optionsData.count - 1 {
            if let cell = optionsTableView.cellForRow(at: [0, index]) as? ProfileStatsCell {
                if cell.accessoryType == .checkmark {
                    selectedOptionsArray.append(optionsData[index])
                    lastSelected.append(index)
                }
            }
        }
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
        for index in lastSelected {
            if indexPath.row == index {
                cell.tag = 1
                cell.accessoryType = .checkmark
            }
        }
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
