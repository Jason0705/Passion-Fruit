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

    
    // MARK: - Variables
    
    struct tableSection {
        var header: String!
        var cell: [String]!
        var showHeader: Bool!
    }
    
    struct picker {
        var data: [String]!
    }
    
    
    var tableData = [tableSection]()
    var pickerData = [picker]()
    
        // section 0
    var selectedProfilePhoto: UIImage?
        // section 1
    var infoCellContent: Array<String> = Array(repeating: "", count: 4) // hold ProfileInfoCell().contentTextView.text
        // section 2 row 0 ~ 7
    var statsCellContent: Array<String> = Array(repeating: "", count: 8) // hold ProfileStatsCell().contentTextView.text
    var statsCellPickerRow: Array<Int> = Array(repeating: 0, count: 8) // hold all pickerData.row
        // section 2 row 8 (last row)
    var selectedLookingData = ""
    var lastSelectedLooking = [Int]()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var agePickerData = (18...100).map {"\($0)"}
    var heightPickerData = (100...250).map {"\($0) cm"}
    var weightPickerData = (40...280).map {"\($0) kg"}
    var wantPickerData = ["Do Not Show", "Have A Relationship", "Have Fun", "Have Both (Require Subscription)"]
    
    
    
    let imageCells = ["Image"]
    let infoCells = ["User Name", "I AM", "I Like", "My Date Would"] // hold infoCell displaying title
    let statsCells = ["Age", "Height", "Weight", "Ethnicity", "Gender", "Preference", "Relationship Status", "I Want To", "I'm Looking For"] // hold statsCell displaying title
    let infoCellPlaceholders = ["This will be displayed on your profile...", "Let people know about you...", "Let people know what you like...", "Let people know what you expect..."]
    
    let ethnicityPickerData = ["Do Not Show", "Asian", "African", "Latino", "Middle Eastern", "Native American", "White", "South Asian", "Mixed", "Other"]
    let genderPickerData = ["Do Not Show", "Male", "Female", "Trans Male", "Trans Female"]
    let preferencePickerData = ["Do Not Show", "Male", "Female", "Trans Male", "Trans Female"]
    let relationshipPickerData = ["Do Not Show", "Single", "Dating", "Exclusive", "Committed", "Engaged", "Partnered", "Married", "Open Relationship", "Separated", "Divorced"]
    let lookingData = ["Love", "Friends", "Dates", "Chat", "Networking", "NSA", "Right Now", "Discreet Fun", "Kinks"]
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileEditTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonView: UIView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell.xib
        profileEditTableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "profileImageCell")
        profileEditTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        profileEditTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
        
        // Set UI State
        doneButtonViewHeight.constant = 0
        doneButton.isHidden = true
        pickerViewHeight.constant = 0
        
        // Call Functions
        populateTableData()
        populatePickerData()
        
        print(selectedLookingData)
    }
    
    
    // MARK: - Functions

    // Pick Profile Photo
    func handleSelectProfilePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Populate table data
    func populateTableData() {
        tableData.removeAll()
        tableData.append(tableSection(header: "IMAGE", cell: imageCells, showHeader: false))
        tableData.append(tableSection(header: "INFO", cell: infoCells, showHeader: true))
        tableData.append(tableSection(header: "STATS", cell: statsCells, showHeader: true))
    }
    
    // Populate picker data
    func populatePickerData() {
        pickerData.removeAll()
        agePickerData.insert("Do Not Show", at: 0)
        heightPickerData.insert("Do Not Show", at: 0)
        weightPickerData.insert("Do Not Show", at: 0)
        pickerData.append(picker(data: agePickerData))
        pickerData.append(picker(data: heightPickerData))
        pickerData.append(picker(data: weightPickerData))
        pickerData.append(picker(data: ethnicityPickerData))
        pickerData.append(picker(data: genderPickerData))
        pickerData.append(picker(data: preferencePickerData))
        pickerData.append(picker(data: relationshipPickerData))
        pickerData.append(picker(data: wantPickerData))
        

    }
    
    
    // UI State
    func doneButtonViewState(state: Int){
        UIView.animate(withDuration: 0.225) {
            // close state
            if state == 0 {
                self.doneButtonViewHeight.constant = 0
                self.doneButton.isHidden = true
                self.pickerViewHeight.constant = 0
                for index in 0...self.infoCells.count - 1 {
                    if let cell = self.profileEditTableView.cellForRow(at: [1,index]) as? ProfileInfoCell {
                        cell.contentTextView.endEditing(true)
                    }
                }
            }
                
                // keyboard editing state
            else if state == 1 {
                self.doneButtonViewHeight.constant = 258 + 44 + 44 // keyboard height + sugest text view height + visable dont button view height
                self.doneButton.isHidden = false
            }
                
                // picker editing state
            else if state == 2 {
                self.pickerViewHeight.constant = 216 // picker view height
                self.doneButtonViewHeight.constant = 216 + 44 // picker view height + visable done button view height
                self.doneButton.isHidden = false
            }
            self.view.layoutIfNeeded()
        }
        
        
    }
    

    // MARK: - IBActions
    
    @IBAction func skipSaveBarButtonPressed(_ sender: UIBarButtonItem) {
        
        print(infoCellContent)
        print(statsCellContent)
        print(statsCellPickerRow)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButtonViewState(state: 0)
    }
    

}

// MARK: - Table View Delegation, Data Source

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
            cell.placeholderLabel.text = infoCellPlaceholders[indexPath.row]
            cell.placeholderLabel.textColor = UIColor.lightGray
            cell.contentTextView.text = infoCellContent[indexPath.row]
            
            if !infoCellContent[indexPath.row].isEmpty {
                cell.placeholderLabel.isHidden = true
            }
            else {
                cell.placeholderLabel.isHidden = false
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileStatsCell", for: indexPath) as! ProfileStatsCell
            cell.titleLabel.text = tableData[indexPath.section].cell[indexPath.row]
            // if last row
            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
                cell.accessoryType = .disclosureIndicator
                cell.contentTextView.text = selectedLookingData
                return cell
            }
            // not last row
            cell.accessoryType = .none
            cell.contentTextView.text = statsCellContent[indexPath.row]
            
            return cell
            
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "profileEditCell", for: indexPath)
    }
    
    // Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            doneButtonViewState(state: 0)
            handleSelectProfilePhoto()
        }
        else if indexPath.section == 1 {
            doneButtonViewState(state: 1)
            if let cell = profileEditTableView.cellForRow(at: indexPath) as? ProfileInfoCell {
                cell.contentTextView.becomeFirstResponder()
            }
        }
        else if indexPath.section == 2 {
            // if last row selected
            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
                performSegue(withIdentifier: "profileEditToProfileOptionVC", sender: self)
            }
                // not last row selected
            else {
                pickerView.reloadAllComponents()
                pickerView.selectRow(statsCellPickerRow[indexPath.row], inComponent: 0, animated: false)
                doneButtonViewState(state: 2)
            }
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileEditToProfileOptionVC" {
            let destinationVC = segue.destination as! ProfileOptionViewController
            destinationVC.optionsData = lookingData
            destinationVC.lastSelected = lastSelectedLooking
            destinationVC.delegate = self
        }
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
        }
        dismiss(animated: true, completion: nil)
        profileEditTableView.reloadData()
    }
}


// MARK: - UI Picker Delegation, Data Source

extension ProfileEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[selectedIndexPath.row].data.count
    }

    // Populate picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[selectedIndexPath.row].data[row]
    }

    // Select row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        statsCellPickerRow[selectedIndexPath.row] = row
        
        if row == 0 {
            statsCellContent[selectedIndexPath.row] = ""
        }
        else {
            statsCellContent[selectedIndexPath.row] = pickerData[selectedIndexPath.row].data[row]
        }
        
        // Update section data
        updateSection(section: 2)
    }
}


// MARK: - Protocols

// Update Custom cell
extension ProfileEditViewController: InfoCell {
    func infoCellContentReceived(content: String) {
        infoCellContent[selectedIndexPath.row] = content
    }
    
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.beginUpdates()
        profileEditTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
}


// Receive Data
extension ProfileEditViewController: ProfileOptionReceive {
    
    func optionReceived(option: String, lastSelected: [Int]) {
        selectedLookingData = option
        lastSelectedLooking = lastSelected
    }
    
    
    func updateSection(section: Int) {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.none)
        UIView.setAnimationsEnabled(true)
    }
    
}

