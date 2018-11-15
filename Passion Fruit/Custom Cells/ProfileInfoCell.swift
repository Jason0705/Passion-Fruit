//
//  ProfileInfoCell.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

protocol InfoCell {
    func updateTableView()
}

class ProfileInfoCell: UITableViewCell {

    var cellDelegate: InfoCell?
    var placeholder = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProfileInfoCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //placeholderLabel.isHidden = true
        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if contentTextView.text.isEmpty {
//            placeholderLabel.isHidden = false
//            return
//        }
//        placeholderLabel.isHidden = true
        if contentTextView.text.isEmpty {
            contentTextView.text = placeholder
            contentTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = contentTextView.frame
        
        let baseHeight: CGFloat = 30
        let height: CGFloat = newSize.height > baseHeight ? newSize.height : baseHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        cellDelegate?.updateTableView()
    }
}
