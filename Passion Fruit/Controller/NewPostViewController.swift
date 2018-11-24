//
//  NewPostViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-23.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
//        doneButtonViewHeight.constant = 300
    }

}



extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneButtonViewHeight.constant = 300
    }
}
