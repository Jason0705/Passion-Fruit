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
    var statsPickerData = [picker]()
    var sexualityPickerData = [picker]()
    
    var from = 0
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
        // section 0
    var selectedProfilePhoto: UIImage?
    var selectedProfilePhotoSaved: UIImage?
        // section 1
    var infoCellContent: Array<String> = Array(repeating: "", count: 4) // hold KeyboardInputCell().contentTextView.text
    var infoCellContentSaved: Array<String> = Array(repeating: "", count: 4)
        // section 2 row 0 ~ 7
    var statsCellContent: Array<String> = Array(repeating: "", count: 6) // hold ProfileStatsCell().contentTextView.text
    var statsCellContentSaved: Array<String> = Array(repeating: "", count: 6)
    var statsCellPickerRow: Array<Int> = Array(repeating: 0, count: 6) // hold all pickerData.row
    var statsCellPickerRowSaved: Array<Int> = Array(repeating: 0, count: 6)
    // section 2 row 8 (last row)
    var selectedLookingData = ""
    var selectedLookingDataSaved = ""
    var lastSelectedLooking = [Int]()
    var lastSelectedLookingSaved = [Int]()
    // section 3
    var genderData = ""
    var genderDataSaved = ""
    var genderPickerRow = 0
    var genderPickerRowSaved = 0
    var selectedInterestedData = ""
    var selectedInterestedDataSaved = ""
    var lastSelectedInterested = [Int]()
    var lastSelectedInterestedSaved = [Int]()
    
    
    var imagePicker = UIImagePickerController()
    
    
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
        profileEditTableView.register(UINib(nibName: "ImageVideoCell", bundle: nil), forCellReuseIdentifier: "imageVideoCell")
        profileEditTableView.register(UINib(nibName: "KeyboardInputCell", bundle: nil), forCellReuseIdentifier: "keyboardInputCell")
        profileEditTableView.register(UINib(nibName: "ProfileStatsCell", bundle: nil), forCellReuseIdentifier: "profileStatsCell")
        
        // Set UI State
        setUp()
        
        // Call Functions
        populateTableData()
        populateStatsPickerData()
        populateSexualityPickerData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonViewState(state: 0)
    }
    
    
    // MARK: - Functions
    
    // Populate table data
    func populateTableData() {
        tableData.removeAll()
        tableData.append(tableSection(header: "IMAGE", cell: StaticVariables.imageCells, showHeader: false))
        tableData.append(tableSection(header: "INFO", cell: StaticVariables.infoCells, showHeader: true))
        tableData.append(tableSection(header: "STATS", cell: StaticVariables.statsCells, showHeader: true))
        tableData.append(tableSection(header: "SEXUALITY", cell: StaticVariables.sexualityCells, showHeader: true))
    }
    
    // Populate picker data
    func populateStatsPickerData() {
        statsPickerData.removeAll()
        StaticVariables.agePickerData.insert("Do Not Show", at: 0)
        StaticVariables.heightPickerData.insert("Do Not Show", at: 0)
        StaticVariables.weightPickerData.insert("Do Not Show", at: 0)
        statsPickerData.append(picker(data: StaticVariables.agePickerData))
        statsPickerData.append(picker(data: StaticVariables.heightPickerData))
        statsPickerData.append(picker(data: StaticVariables.weightPickerData))
        statsPickerData.append(picker(data: StaticVariables.ethnicityPickerData))
        statsPickerData.append(picker(data: StaticVariables.relationshipPickerData))
        statsPickerData.append(picker(data: StaticVariables.wantPickerData))
    }
    
    func populateSexualityPickerData() {
        sexualityPickerData.removeAll()
        sexualityPickerData.append(picker(data: StaticVariables.genderPickerData))
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
        if selectedProfilePhoto != selectedProfilePhotoSaved || infoCellContent != infoCellContentSaved || statsCellContent != statsCellContentSaved || statsCellPickerRow != statsCellPickerRowSaved || selectedLookingData != selectedLookingDataSaved || lastSelectedLooking != lastSelectedLookingSaved || genderData != genderDataSaved || genderPickerRow != genderPickerRowSaved || selectedInterestedData != selectedInterestedDataSaved || lastSelectedInterested != lastSelectedInterestedSaved {
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
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.none)
        
        if Auth.auth().currentUser != nil { // User signed in
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
            let storageReference = Storage.storage().reference()
            
            let userReference = databaseReference.child("users").child(uid!) // : https://passion-fruit-39bda.firebaseio.com/users/uid
            let profilePhotoReference = storageReference.child("profile_images").child("\(uid!).jpg")
            
            // Save profile photo
            if let profilePhoto = selectedProfilePhoto, let imageData = profilePhoto.jpegData(compressionQuality: 0.1) {
                profilePhotoReference.putData(imageData, metadata: nil) { (storageMetadata, error) in
                    if error != nil { // error
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    profilePhotoReference.downloadURL(completion: { (url, error) in
                        if error != nil { // error
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let profilePhotoURL = url?.absoluteString
//                        userReference.child("/profile").child("/profile_photo_url").setValue(profilePhotoURL)
                        userReference.child("/profile_photo_url").setValue(profilePhotoURL)
                    })
                }
            }
//            userReference.child("/profile").child("/profile_photo_url").setValue("")
            userReference.child("/profile_photo_url").setValue("")
            
//            // Save info data
//            userReference.child("/profile").child("/user_info").child("user_name").setValue(infoCellContent[0])
//            userReference.child("/profile").child("/user_info").child("i_am").setValue(infoCellContent[1])
//            userReference.child("/profile").child("/user_info").child("i_like").setValue(infoCellContent[2])
//            userReference.child("/profile").child("/user_info").child("my_date_would").setValue(infoCellContent[3])
//
//            // Save stats data
//            userReference.child("/profile").child("/user_stats").child("age").child("content").setValue(statsCellContent[0])
//            userReference.child("/profile").child("/user_stats").child("age").child("row").setValue(statsCellPickerRow[0])
//            userReference.child("/profile").child("/user_stats").child("height").child("content").setValue(statsCellContent[1])
//            userReference.child("/profile").child("/user_stats").child("height").child("row").setValue(statsCellPickerRow[1])
//            userReference.child("/profile").child("/user_stats").child("weight").child("content").setValue(statsCellContent[2])
//            userReference.child("/profile").child("/user_stats").child("weight").child("row").setValue(statsCellPickerRow[2])
//            userReference.child("/profile").child("/user_stats").child("ethnicity").child("content").setValue(statsCellContent[3])
//            userReference.child("/profile").child("/user_stats").child("ethnicity").child("row").setValue(statsCellPickerRow[3])
//            userReference.child("/profile").child("/user_stats").child("relationship_status").child("content").setValue(statsCellContent[4])
//            userReference.child("/profile").child("/user_stats").child("relationship_status").child("row").setValue(statsCellPickerRow[4])
//            userReference.child("/profile").child("/user_stats").child("want").child("content").setValue(statsCellContent[5])
//            userReference.child("/profile").child("/user_stats").child("want").child("row").setValue(statsCellPickerRow[5])
//            userReference.child("/profile").child("/user_stats").child("looking_for").child("content").setValue(selectedLookingData)
//            userReference.child("/profile").child("/user_stats").child("looking_for").child("row").setValue(lastSelectedLooking)
//
//            // Save sexuality data
//            userReference.child("/profile").child("/user_sexuality").child("gender").child("content").setValue(genderData)
//            userReference.child("/profile").child("/user_sexuality").child("gender").child("row").setValue(genderPickerRow)
//            userReference.child("/profile").child("/user_sexuality").child("interested").child("content").setValue(selectedInterestedData)
//            userReference.child("/profile").child("/user_sexuality").child("interested").child("row").setValue(lastSelectedInterested)
            
            // Save info data
            userReference.child("user_name").setValue(infoCellContent[0])
            userReference.child("i_am").setValue(infoCellContent[1])
            userReference.child("i_like").setValue(infoCellContent[2])
            userReference.child("my_date_would").setValue(infoCellContent[3])
            
            // Save stats data
            
            userReference.child("age").setValue(statsCellPickerRow[0])
            userReference.child("height").setValue(statsCellPickerRow[1])
            userReference.child("weight").setValue(statsCellPickerRow[2])
            userReference.child("ethnicity").setValue(statsCellPickerRow[3])
            userReference.child("relationship_status").setValue(statsCellPickerRow[4])
            userReference.child("want").setValue(statsCellPickerRow[5])
            userReference.child("looking_for").setValue(lastSelectedLooking)
            
            // Save sexuality data
            userReference.child("gender").setValue(genderPickerRow)
            userReference.child("interested").setValue(lastSelectedInterested)
            
            SVProgressHUD.showSuccess(withStatus: "Changes Saved")
            SVProgressHUD.dismiss(withDelay: 1)
        }
        else { // user authenticatin error
            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
            SVProgressHUD.dismiss(withDelay: 2)
        }
    }
    

    // MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        doneButtonViewState(state: 0)
        if genderPickerRow == 0 { // not to show gender
            let alert = UIAlertController(title: "Attention", message: "Not showing your gender makes it hard for others to find your profile. Are you sure you want to continue without showing your gender?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (AlertAction) in
                alert.dismiss(animated: true, completion: nil)
                self.saveProfile()
                if self.from == 1 {
                    // Navigate to MainTabBarController
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                    self.present(mainTabBarController, animated: true, completion: nil)
                    return
                }
            }
            let noAction = UIAlertAction(title: "No", style: .default) { (AlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            saveProfile()
            if from == 1 {
                // Navigate to MainTabBarController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                self.present(mainTabBarController, animated: true, completion: nil)
                return
            }
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButtonViewState(state: 0)
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        if let origin = segue.source as? CapturePreviewViewController {
            if origin.photo != nil {
                selectedProfilePhoto = origin.photo
            }
            
            profileEditTableView.reloadData()
            // Do something with the data
        }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageVideoCell", for: indexPath) as! ImageVideoCell
            cell.profilePhotoImageView.image = selectedProfilePhoto
            
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "keyboardInputCell", for: indexPath) as! KeyboardInputCell
            cell.cellDelegate = self
            cell.titleLabel.text = tableData[indexPath.section].cell[indexPath.row]
            cell.placeholderLabel.text = StaticVariables.infoCellPlaceholders[indexPath.row]
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
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileStatsCell", for: indexPath) as! ProfileStatsCell
            cell.titleLabel.text = tableData[indexPath.section].cell[indexPath.row]
            // if last row
            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
                cell.accessoryType = .disclosureIndicator
                cell.contentTextView.text = selectedInterestedData
                return cell
            }
            // not last row
            cell.accessoryType = .none
            cell.contentTextView.text = genderData
            
            return cell
            
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "profileEditCell", for: indexPath)
    }
    
    // Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        switch indexPath.section {
        case 0:
            doneButtonViewState(state: 0)
            handleSelectProfilePhoto()
            
        case 1:
            doneButtonViewState(state: 1)
            if let cell = profileEditTableView.cellForRow(at: indexPath) as? KeyboardInputCell {
                cell.contentTextView.becomeFirstResponder()
            }
            
        case 2:
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
            
        case 3:
            // if last row selected
            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
                performSegue(withIdentifier: "profileEditToProfileOptionVC", sender: self)
            }
                // not last row selected
            else {
                pickerView.reloadAllComponents()
                pickerView.selectRow(genderPickerRow, inComponent: 0, animated: false)
                doneButtonViewState(state: 2)
            }
            
        default:
            break
        }
//        if indexPath.section == 0 {
//            doneButtonViewState(state: 0)
//            handleSelectProfilePhoto()
//        }
//        else if indexPath.section == 1 {
//            doneButtonViewState(state: 1)
//            if let cell = profileEditTableView.cellForRow(at: indexPath) as? KeyboardInputCell {
//                cell.contentTextView.becomeFirstResponder()
//            }
//        }
//        else if indexPath.section == 2 {
//            // if last row selected
//            if indexPath.row == tableData[indexPath.section].cell.count - 1 {
//                performSegue(withIdentifier: "profileEditToProfileOptionVC", sender: self)
//            }
//                // not last row selected
//            else {
//                pickerView.reloadAllComponents()
//                pickerView.selectRow(statsCellPickerRow[indexPath.row], inComponent: 0, animated: false)
//                doneButtonViewState(state: 2)
//            }
//        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileEditToProfileOptionVC" {
            let destinationVC = segue.destination as! ProfileOptionViewController
            destinationVC.delegate = self
            destinationVC.fromSection = selectedIndexPath.section
            if selectedIndexPath.section == 2 {
                destinationVC.optionsData = StaticVariables.lookingData
                destinationVC.lastSelected = lastSelectedLooking
            }
            else if selectedIndexPath.section == 3 {
                destinationVC.optionsData = StaticVariables.interestedData
                destinationVC.lastSelected = lastSelectedInterested
            }
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
        if selectedIndexPath.section == 2 {
            return statsPickerData[selectedIndexPath.row].data.count
        }
        else if selectedIndexPath.section == 3 {
            return sexualityPickerData[selectedIndexPath.row].data.count
        }
        
        return 0
    }

    // Populate picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedIndexPath.section == 2 {
            return statsPickerData[selectedIndexPath.row].data[row]
        }
        else if selectedIndexPath.section == 3 {
            return sexualityPickerData[selectedIndexPath.row].data[row]
        }
        return ""
    }

    // Select row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedIndexPath.section == 2 {
            statsCellPickerRow[selectedIndexPath.row] = row
            
            if row == 0 {
                statsCellContent[selectedIndexPath.row] = ""
            }
            else {
                statsCellContent[selectedIndexPath.row] = statsPickerData[selectedIndexPath.row].data[row]
            }
            updateSection(section: 2)
        }
        else if selectedIndexPath.section == 3 {
            genderPickerRow = row
            
            if row == 0 {
                genderData = ""
            }
            else {
                genderData = sexualityPickerData[selectedIndexPath.row].data[row]
            }
            updateSection(section: 3)
        }
        
        updateSaveBarButton()
    }
}


// MARK: - Protocols

// Update Custom cell
extension ProfileEditViewController: KeyboardInputCellProtocal {
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
        if selectedIndexPath.section == 2 {
            selectedLookingData = option
            lastSelectedLooking = lastSelected
        }
        else if selectedIndexPath.section == 3 {
            selectedInterestedData = option
            lastSelectedInterested = lastSelected
        }
        updateSaveBarButton()
    }
    
    
    func updateSection(section: Int) {
        UIView.setAnimationsEnabled(false)
        profileEditTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.none)
        profileEditTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}

