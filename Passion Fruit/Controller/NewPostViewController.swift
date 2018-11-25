//
//  NewPostViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-23.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    
    // Variables
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
//    var postMedia
    var caption = ""
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newPostTableView: UITableView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell.xib
        newPostTableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "profileImageCell")
        newPostTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        
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
            self.tabBarController?.selectedIndex = StaticVariables.tabBarSelected
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleSelectPostMedia() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
//            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
//            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
//            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func handleSharePost() {
        let alert = UIAlertController(title: "Share as:", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Public Post", style: .default, handler: { _ in
            self.savePublic()
        }))
        
        alert.addAction(UIAlertAction(title: "Private Post", style: .default, handler: { _ in
            self.savePrivate()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Save as public post
    func savePublic() {
        
    }
    
    // Save as private post
    func savePrivate() {
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath) as! ProfileImageCell
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            cell.cellDelegate = self
            cell.titleLabel.text = "Caption"
            cell.placeholderLabel.text = "Write a caption..."
            
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
            if let cell = newPostTableView.cellForRow(at: indexPath) as? ProfileInfoCell {
                cell.contentTextView.becomeFirstResponder()
            }
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
}


// MARK: - Protocols

// Update Custom cell
extension NewPostViewController: InfoCell {
    func infoCellContentReceived(content: String) {
        caption = content
//        updateSaveBarButton()
    }
    
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        newPostTableView.beginUpdates()
        newPostTableView.endUpdates()
        newPostTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}
