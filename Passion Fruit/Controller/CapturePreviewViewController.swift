//
//  CapturePreviewViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-27.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class CapturePreviewViewController: UIViewController {

    // MARK: - Variables
    
    let option = 0
    
    var photo: UIImage?
    var videoURL: URL?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showPreview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch option {
        case 0:
            VideoService.player.isMuted = true
            
        case 1:
            VideoService.player.isMuted = false
            
        default:
            break
        }
    }
    
    // MARK: - Functions
    
    func showPreview() {
        if photo != nil { // show photo
            previewImageView.isHidden = false
            previewImageView.image = photo
            print("see photo!!!")
        }
        else if videoURL != nil { // show video
            previewImageView.isHidden = true
            VideoService.createAVPlayerLayer(on: previewView, with: videoURL!)
        }
    }
    
    
    

    // MARK: - IBActions
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        if VideoService.player != nil {
            VideoService.player.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
    }
    
}
