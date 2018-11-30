//
//  KeyboardInputCell.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

protocol KeyboardInputCellProtocal {
    func infoCellContentReceived(content: String)
    func updateTableView()
}

class KeyboardInputCell: UITableViewCell {

    var cellDelegate: KeyboardInputCellProtocal?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
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

extension KeyboardInputCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            placeholderLabel.isHidden = false
            return
        }
        placeholderLabel.isHidden = true
//        cellDelegate?.infoCellContentReceived(content: contentTextView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        cellDelegate?.infoCellContentReceived(content: contentTextView.text)
        cellDelegate?.updateTableView()
    }
}
