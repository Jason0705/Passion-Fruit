//
//  ProfilePhotoViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-05.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfilePhotoViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    
    var selectedProfilePhoto: UIImage?
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // State Preperation
        nextButton.isEnabled = false
        
        let tapGesture_profilePhotoImageView = UITapGestureRecognizer(target: self, action: #selector(ProfilePhotoViewController.handleSelectProfilePhoto))
        profilePhotoImageView.addGestureRecognizer(tapGesture_profilePhotoImageView)
        profilePhotoImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Functions
    
    // Pick Profile Photo
    @objc func handleSelectProfilePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
        nextButton.isEnabled = true
    }
    
    // Save Profile Photo
    func saveProfilePhoto() {
        if Auth.auth().currentUser != nil {
            // User signed in
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let storageReference = Storage.storage().reference()
            let profilePhotoReference = storageReference.child("profile_images").child("\(uid!).jpg")
            if let profilePhoto = selectedProfilePhoto, let imageData = profilePhoto.jpegData(compressionQuality: 0.1) {
                profilePhotoReference.putData(imageData, metadata: nil) { (storageMetadata, error) in
                    if error != nil {
                        print("Save profile photo error: \(error!)")
                        return
                    }
                    // no error
                    profilePhotoReference.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("Get profile photo URL error: \(error!)")
                            return
                        }
                        // no error
                        let profilePhotoURL = url?.absoluteString
                        let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
                        let userReference = databaseReference.child("users").child(uid!) // : https://passion-fruit-39bda.firebaseio.com/users/uid
                        userReference.child("/profilePhotoURL").setValue(profilePhotoURL)
                    })
                }
            }
            let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
            let userReference = databaseReference.child("users").child(uid!) // : https://passion-fruit-39bda.firebaseio.com/users/uid
            userReference.child("/profilePhotoURL").setValue("")
        }
        performSegue(withIdentifier: "profilePhotoToUserInfoVC", sender: nil)
        // User not signed in
    }
    
    
    // MARK: - IBActions
    
    @IBAction func skipBarButtonPressed(_ sender: UIBarButtonItem) {
        saveProfilePhoto()
    }
    
    @IBAction func selectPhotoButtonPressed(_ sender: UIButton) {
        handleSelectProfilePhoto()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // Save profile photo to Firebase Storage and the url to Firebase Database
        saveProfilePhoto()
    }
}



// MARK: - Image Picker Delegation
extension ProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedProfilePhoto = image
            profilePhotoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
