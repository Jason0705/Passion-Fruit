//
//  ProfileEditViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileEditViewController: UIViewController {

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileEditTableView: UITableView!
    
    
    // MARK: - Variables
    
    struct tableSection {
        var header: String!
        var cell: [String]!
        var showHeader: Bool!
    }
    
    var tableData = [tableSection]()
    
    var selectedProfilePhoto: UIImage?
    //var infoCellContent = [String]()
    
    
    let imageCells = ["image"]
    let infoCells = ["User Name", "I AM", "I Like", "My Date Would"]
    let statsCells = ["Age", "Height", "Weight", "Ethnicity", "Gender", "Preference", "Relationship Status", "I'm Looking For", "I'm Into"]
    let infoCellPlaceholders = ["This will be displayed on your profile...", "Let people know about you...", "Let people know what you like...", "Let people know what you expect..."]
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register OrderCell.xib
        profileEditTableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "profileImageCell")
        profileEditTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        profileEditTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
        
        populateTableData()
    }
    
    
    // MARK: - Functions

    // Pick Profile Photo
    func handleSelectProfilePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Populate table
    func populateTableData() {
        tableData.removeAll()
        tableData.append(tableSection(header: "IMAGE", cell: imageCells, showHeader: false))
        tableData.append(tableSection(header: "INFO", cell: infoCells, showHeader: true))
        tableData.append(tableSection(header: "STATS", cell: statsCells, showHeader: true))
    }
    


}

// MARK: - Table View Delegation and Data Source

extension ProfileEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData[section].cell.count
        
    }
    
    // Populate Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath) as! ProfileImageCell
            cell.profilePhotoImageView.image = selectedProfilePhoto
            
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            cell.cellDelegate = self
            cell.titleLabel.text = tableData[indexPath.section].cell[indexPath.row]
//            cell.placeholderLabel.text = infoCellPlaceholders[indexPath.row]
//            cell.placeholderLabel.textColor = UIColor.lightGray
            cell.placeholder = infoCellPlaceholders[indexPath.row]
            cell.contentTextView.text = cell.placeholder
            cell.contentTextView.textColor = UIColor.lightGray
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileStatsCell", for: indexPath) as! ProfileStatsCell
            cell.titleLabel.text = tableData[indexPath.section].cell[indexPath.row]
            cell.accessoryType = .none
            
            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
            
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "profileEditCell", for: indexPath)
    }
    
    // Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0,0] {
            handleSelectProfilePhoto()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    // MARK: - Section Header
    
    // Header Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tableData[section].header
    }
    
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if !tableData[section].showHeader {
            return 0
        }
        return 50
    }
    
    // Header View
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.ultraLight);
    }
    
}

// MARK: - Image Picker Delegation

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedProfilePhoto = image
            //profilePhotoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
        profileEditTableView.reloadData()
    }
}


// MARK: - Update Custom Cell

// Update cell
extension ProfileEditViewController: InfoCell {
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.beginUpdates()
        profileEditTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
}

