//
//  NewPostViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-23.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD


class NewPostViewController: UIViewController {

    
    // Variables
    
    let defaults = UserDefaults.standard
    
    let defaultPostImage = UIImage(named: "add")
    
    var imagePicker = UIImagePickerController()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var selectedPostimage: UIImage? // save to firebase/storage
    var selectedVideoURL: URL? // save to firebase/storage
//    var croppedVideoURL: URL? // save to firebase/storage
    var caption = "" // save to firebase/storage
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newPostTableView: UITableView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imagePicker delegate
        imagePicker.delegate = self
        
        // Register Cell.xib
        newPostTableView.register(UINib(nibName: "ImageVideoCell", bundle: nil), forCellReuseIdentifier: "imageVideoCell")
        newPostTableView.register(UINib(nibName: "KeyboardInputCell", bundle: nil), forCellReuseIdentifier: "keyboardInputCell")
        
        // Set UI State
        setUp()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonViewState(state: 0)
    }
    
    
    // MARK: - Functions
    
    func setUp() {
        doneButtonViewHeight.constant = 0
        doneButton.isHidden = true
        newPostTableView.separatorStyle = .none
        
        updateShareBarButton()
    }
    
    func updateShareBarButton() {
        if selectedPostimage != nil || selectedVideoURL != nil || !caption.isEmpty {
            shareBarButton.isEnabled = true
        }
        else {
            shareBarButton.isEnabled = false
        }
    }

    func doneButtonViewState(state: Int){
        UIView.animate(withDuration: 0.225) {
            // close state
            if state == 0 {
                self.doneButtonViewHeight.constant = 0
                self.doneButton.isHidden = true
                self.view.endEditing(true)
            }
                
                // keyboard editing state
            else if state == 1 {
                self.doneButtonViewHeight.constant = 258 + 44 + 44 // keyboard height + sugest text view height + visable dont button view height
                self.doneButton.isHidden = false
            }
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    func handleCancelPost() {
        let alert = UIAlertController(title: "If you go back now, yor post will be discarded.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            if VideoService.player != nil {
                VideoService.player.pause()
            }
            self.selectedPostimage = nil
            self.selectedVideoURL = nil
            self.caption = ""
            self.newPostTableView.reloadData()
            self.updateShareBarButton()
            self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleSelectPostMedia() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        let storyboard = UIStoryboard(name: "CustomCamera", bundle: nil)
        let customCameraVC = storyboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraViewController
        customCameraVC.videoEnabled = true
        self.present(customCameraVC, animated: true, completion: nil)
    }
    
    
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func handleSharePost() {
        let alert = UIAlertController(title: "Share as:", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Public Post", style: .default, handler: { _ in
            self.savePost(as: "public")
        }))
        
        alert.addAction(UIAlertAction(title: "Private Post", style: .default, handler: { _ in
            self.savePost(as: "private")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Save as public post
    func savePost(as state: String) {
        
        if Auth.auth().currentUser != nil { // user signed in
            
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.none)
            
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let databaseRefernce = Database.database().reference()
            let storageReference = Storage.storage().reference()
            
            let postReference = databaseRefernce.child("posts").child(state)
            let newPostID = postReference.childByAutoId().key
            let newPostReference = postReference.child(newPostID!)
            
            let imageVideoID = NSUUID().uuidString
            let imageReference = storageReference.child("posts").child(state).child("\(imageVideoID).jpg")
            let videoReference = storageReference.child("posts").child(state).child("\(imageVideoID).mp4")
            
            if selectedPostimage != nil {
                let imageData = selectedPostimage!.jpegData(compressionQuality: 0.1)
                imageReference.putData(imageData!, metadata: nil) { (storageMetadata, error) in
                    if error != nil { // error
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    imageReference.downloadURL(completion: { (url, error) in
                        if error != nil { // error
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let postImageURL = url?.absoluteString
                        newPostReference.child("/image_url").setValue(postImageURL)
                    })
                }
            }
            
            else if selectedVideoURL != nil {
                videoReference.putFile(from: selectedVideoURL!, metadata: nil) { (storageMetadata, error) in
                    if error != nil { // error
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    videoReference.downloadURL(completion: { (url, error) in
                        if error != nil { // error
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let postVideoURL = url?.absoluteString
                        newPostReference.child("/video_url").setValue(postVideoURL)
                    })
                }
            }
            
            newPostReference.child("/caption").setValue(caption)
            newPostReference.child("/uid").setValue(uid)
            newPostReference.child("/post_id").setValue(newPostID)
            newPostReference.child("/timestamp").setValue(ServerValue.timestamp())
            
            SVProgressHUD.showSuccess(withStatus: "Post Shared")
            SVProgressHUD.dismiss(withDelay: 1)
            
            if VideoService.player != nil {
                VideoService.player.pause()
            }
            self.selectedPostimage = nil
            self.selectedVideoURL = nil
            self.caption = ""
            self.newPostTableView.reloadData()
            self.updateShareBarButton()
            self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
        }
        
        else { // user authentication error
            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        handleCancelPost()
    }
    
    @IBAction func shareBarButtonPressed(_ sender: Any) {
        handleSharePost()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButtonViewState(state: 0)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        if let origin = segue.source as? CapturePreviewViewController {
            if origin.photo != nil {
                selectedPostimage = origin.photo
                selectedVideoURL = nil
            }
            else if origin.videoURL != nil {
                selectedVideoURL = origin.videoURL
                selectedPostimage = nil
            }
            
            newPostTableView.reloadData()
            updateShareBarButton()
        }
    }
    
}



// MARK: - Table View Delegate, Data Source

extension NewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Populate Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageVideoCell", for: indexPath) as! ImageVideoCell
            cell.cellDelegate = self
            if selectedPostimage != nil {
                cell.imageContainerView.isHidden = false
                cell.videoContainerView.isHidden = true
                cell.profilePhotoImageView.image = selectedPostimage
            }
            else if selectedVideoURL != nil {
                cell.imageContainerView.isHidden = true
                cell.videoContainerView.isHidden = false
                VideoService.createAVPlayerLayer(on: cell.videoPreviewView, with: selectedVideoURL!)
                VideoService.player.isMuted = true
//                if let videoURL = selectedVideoURL {
//                    VideoService.cropVideo(videoURL as URL) { (url) in
//                        self.croppedVideoURL = url
//                        VideoService.createAVPlayerLayer(on: cell.videoContainerView, with: url)
//                    }
//                }
            }
            else if selectedPostimage == nil && selectedVideoURL == nil {
                cell.imageContainerView.isHidden = false
                cell.videoContainerView.isHidden = true
                cell.profilePhotoImageView.image = defaultPostImage
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "keyboardInputCell", for: indexPath) as! KeyboardInputCell
            cell.cellDelegate = self
            cell.titleLabel.text = "Caption"
            cell.placeholderLabel.text = "Write a caption..."
            
            if caption.isEmpty {
                cell.placeholderLabel.isHidden = false
                cell.contentTextView.text = ""
            }
            
            return cell
            
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "newPostCell", for: indexPath)
    }
    
    // Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            doneButtonViewState(state: 0)
            handleSelectPostMedia()
        }
        else if indexPath.section == 1 {
            doneButtonViewState(state: 1)
            if let cell = newPostTableView.cellForRow(at: indexPath) as? KeyboardInputCell {
                cell.contentTextView.becomeFirstResponder()
            }
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
}


// MARK: - UI Image Picker Delegation

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType:String = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        if mediaType == "public.image" {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                selectedPostimage = editedImage
                selectedVideoURL = nil
            }
        }
        else if mediaType == "public.movie" {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] {
                selectedVideoURL = videoURL as? URL
                selectedPostimage = nil
            }
        }
        dismiss(animated: true, completion: nil)
        newPostTableView.reloadData()
        updateShareBarButton()
    }
}


// MARK: - Protocols

// Update Custom cell
extension NewPostViewController: KeyboardInputCellProtocal {
    func infoCellContentReceived(content: String) {
        caption = content
        updateShareBarButton()
    }
    
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        newPostTableView.beginUpdates()
        newPostTableView.endUpdates()
        newPostTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}


extension NewPostViewController: ImageVideoCellProtocal {
    func audioOn() {
        if selectedVideoURL != nil {
            VideoService.player.isMuted = false
        }
    }
    
    func audioOff() {
        if selectedVideoURL != nil {
            VideoService.player.isMuted = true
        }
    }
    
}
