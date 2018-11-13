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
    
    var selectedProfilePhoto: UIImage?
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register OrderCell.xib
        profileEditTableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "profileImageCell")
    }
    
    
    // MARK: - Functions

    // Pick Profile Photo
    func handleSelectProfilePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)

    }
    


}

// MARK: - Table View Delegation and Data Source

extension ProfileEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRow = 5
        
        if section == 0 {
            numberOfRow = 1
        }
        else if section == 1 {
            numberOfRow = 4
        }
        else if section == 2 {
            numberOfRow = 9
        }
        
        return numberOfRow
        
    }
    
    // Populate Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "profileEditCell", for: indexPath)
        //cell.textLabel?.text = "\(indexPath)"
        if indexPath == [0,0] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath) as! ProfileImageCell
            cell.profilePhotoImageView.image = selectedProfilePhoto
            return cell
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
        var title = "Section: \(section)"
        
        if section == 0 {
            title = "IMAGE"
        }
        else if section == 1 {
            title = "INFO"
        }
        else if section == 2 {
            title = "STATS"
        }
        return title
    }
    
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 50
        
        if section == 0 {
            height = 0
        }
        
        return height
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
