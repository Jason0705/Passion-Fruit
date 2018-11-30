//
//  ProfileImageCell.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

protocol imageVideoCellProtocal {
    func audioOn()
    func audioOff()
}

class ProfileImageCell: UITableViewCell {
    
    var cellDelegate: imageVideoCellProtocal?
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    func audioControl() {
        if audioButton.tag == 0 { // sound off
            audioButton.tag = 1
            cellDelegate?.audioOn()
            audioButton.setImage(UIImage(named: "sound_on"), for: .normal)
        }
        else if audioButton.tag == 1 { // sound on
            audioButton.tag = 0
            cellDelegate?.audioOff()
            audioButton.setImage(UIImage(named: "sound_off"), for: .normal)
        }
    }
    
    
    @IBAction func audioButtonPressed(_ sender: UIButton) {
        audioControl()
    }
    
}
