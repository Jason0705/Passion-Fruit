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
import SVProgressHUD

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
    
    var from = 0
    
        // section 0
    var selectedProfilePhoto: UIImage?
    var selectedProfilePhotoCompare: UIImage?
        // section 1
    var infoCellContent: Array<String> = Array(repeating: "", count: 4) // hold ProfileInfoCell().contentTextView.text
    var infoCellContentCompare: Array<String> = Array(repeating: "", count: 4)
        // section 2 row 0 ~ 7
    var statsCellContent: Array<String> = Array(repeating: "", count: 8) // hold ProfileStatsCell().contentTextView.text
    var statsCellContentCompare: Array<String> = Array(repeating: "", count: 8)
    var statsCellPickerRow: Array<Int> = Array(repeating: 0, count: 8) // hold all pickerData.row
        // section 2 row 8 (last row)
    var statsCellPickerRowCompare: Array<Int> = Array(repeating: 0, count: 8)
    var selectedLookingData = ""
    var selectedLookingDataCompare = ""
    var lastSelectedLooking = [Int]()
    var lastSelectedLookingCompare = [Int]()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var agePickerData = (18...100).map {"\($0)"}
    var heightPickerData = (100...250).map {"\($0) cm"}
    var weightPickerData = (40...280).map {"\($0) kg"}
    var wantPickerData = ["Do Not Show", "Have A Relationship", "Have Fun", "Have Both (Require Subscription)"]
    
    var imagePicker = UIImagePickerController()
    
    
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
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonView: UIView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // imagePicker delegate
        imagePicker.delegate = self
        
        // Register Cell.xib
        profileEditTableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "profileImageCell")
        profileEditTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        profileEditTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
        
        // Set UI State
        setUp()
        
        // Call Functions
        populateTableData()
        populatePickerData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonViewState(state: 0)
    }
    
    
    // MARK: - Functions
    
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
    func setUp() {
        doneButtonViewHeight.constant = 0
        doneButton.isHidden = true
        pickerViewHeight.constant = 0
        navigationItem.title = "Edit"
        saveBarButton.isEnabled = false
        saveBarButton.title = ""
        if from == 1 {
            navigationItem.title = "Set Up"
            saveBarButton.isEnabled = true
            saveBarButton.title = "Skip"
        }
    }
    
    func doneButtonViewState(state: Int){
        UIView.animate(withDuration: 0.225) {
            // close state
            if state == 0 {
                self.doneButtonViewHeight.constant = 0
                self.doneButton.isHidden = true
                self.pickerViewHeight.constant = 0
                self.view.endEditing(true)
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
    
    // Update save bar button state
    func updateSaveBarButton() {
        if selectedProfilePhoto != selectedProfilePhotoCompare || infoCellContent != infoCellContentCompare || statsCellContent != statsCellContentCompare || statsCellPickerRow != statsCellPickerRowCompare || selectedLookingData != selectedLookingDataCompare || lastSelectedLooking != lastSelectedLookingCompare {
            saveBarButton.isEnabled = true
            saveBarButton.title = "Save"
        }
        else if from == 1 { // from sign up page
            saveBarButton.isEnabled = true
            saveBarButton.title = "Skip"
        }
        else if from == 0 { // from profile page
            saveBarButton.isEnabled = false
            saveBarButton.title = ""
        }
    }
    
    // Pick Profile Photo
    func handleSelectProfilePhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
//        {
//            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = true
//            present(imagePicker, animated: true, completion: nil)
//        }
//        else
//        {
//            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
        let storyboard = UIStoryboard(name: "CustomCamera", bundle: nil)
        let customCameraVC = storyboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraViewController
        customCameraVC.videoEnabled = false
        self.present(customCameraVC, animated: true, completion: nil)
    }
    
    func openLibrary()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Save data to firebase
    func saveProfile() {
        
        if Auth.auth().currentUser != nil {
            // User signed in
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
            let userReference = databaseReference.child("users").child(uid!) // : https://passion-fruit-39bda.firebaseio.com/users/uid
            
            let storageReference = Storage.storage().reference()
            let profilePhotoReference = storageReference.child("profile_images").child("\(uid!).jpg")
            
            // Save profile photo
            if let profilePhoto = selectedProfilePhoto, let imageData = profilePhoto.jpegData(compressionQuality: 0.1) {
                profilePhotoReference.putData(imageData, metadata: nil) { (storageMetadata, error) in
                    if error != nil {
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    profilePhotoReference.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let profilePhotoURL = url?.absoluteString
                        userReference.child("/profile").child("/profile_photo_url").setValue(profilePhotoURL)
                    })
                }
            }
            userReference.child("/profile").child("/profile_photo_url").setValue("")
            
            // Save info data
            userReference.child("/profile").child("/user_info").child("user_name").setValue(infoCellContent[0])
            userReference.child("/profile").child("/user_info").child("i_am").setValue(infoCellContent[1])
            userReference.child("/profile").child("/user_info").child("i_like").setValue(infoCellContent[2])
            userReference.child("/profile").child("/user_info").child("my_date_would").setValue(infoCellContent[3])
            
            // Save stats data
            userReference.child("/profile").child("/user_stats").child("age").child("content").setValue(statsCellContent[0])
            userReference.child("/profile").child("/user_stats").child("age").child("row").setValue(statsCellPickerRow[0])
            userReference.child("/profile").child("/user_stats").child("height").child("content").setValue(statsCellContent[1])
            userReference.child("/profile").child("/user_stats").child("height").child("row").setValue(statsCellPickerRow[1])
            userReference.child("/profile").child("/user_stats").child("weight").child("content").setValue(statsCellContent[2])
            userReference.child("/profile").child("/user_stats").child("weight").child("row").setValue(statsCellPickerRow[2])
            userReference.child("/profile").child("/user_stats").child("ethnicity").child("content").setValue(statsCellContent[3])
            userReference.child("/profile").child("/user_stats").child("ethnicity").child("row").setValue(statsCellPickerRow[3])
            userReference.child("/profile").child("/user_stats").child("gender").child("content").setValue(statsCellContent[4])
            userReference.child("/profile").child("/user_stats").child("gender").child("row").setValue(statsCellPickerRow[4])
            userReference.child("/profile").child("/user_stats").child("preference").child("content").setValue(statsCellContent[5])
            userReference.child("/profile").child("/user_stats").child("preference").child("row").setValue(statsCellPickerRow[5])
            userReference.child("/profile").child("/user_stats").child("relationship_status").child("content").setValue(statsCellContent[6])
            userReference.child("/profile").child("/user_stats").child("relationship_status").child("row").setValue(statsCellPickerRow[6])
            userReference.child("/profile").child("/user_stats").child("want_to").child("content").setValue(statsCellContent[7])
            userReference.child("/profile").child("/user_stats").child("want_to").child("row").setValue(statsCellPickerRow[7])
            userReference.child("/profile").child("/user_stats").child("looking_for").child("content").setValue(selectedLookingData)
            userReference.child("/profile").child("/user_stats").child("looking_for").child("row").setValue(lastSelectedLooking)
            
            SVProgressHUD.showSuccess(withStatus: "Changes Saved")
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
        // User not signed in
    }
    

    // MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        doneButtonViewState(state: 0)
        saveProfile()
        if from == 1 {
            // Navigate to MainTabBarController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(mainTabBarController, animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
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


// MARK: - UI Image Picker Delegation

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedProfilePhoto = editedImage
            updateSaveBarButton()
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
        updateSaveBarButton()
    }
}


// MARK: - Protocols

// Update Custom cell
extension ProfileEditViewController: InfoCell {
    func infoCellContentReceived(content: String) {
        infoCellContent[selectedIndexPath.row] = content
        updateSaveBarButton()
    }
    
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.beginUpdates()
        profileEditTableView.endUpdates()
        profileEditTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}


// Receive Data
extension ProfileEditViewController: ProfileOptionReceive {
    
    func optionReceived(option: String, lastSelected: [Int]) {
        selectedLookingData = option
        lastSelectedLooking = lastSelected
        updateSaveBarButton()
    }
    
    
    func updateSection(section: Int) {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.none)
        profileEditTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}

