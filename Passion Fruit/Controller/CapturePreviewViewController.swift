//
//  CapturePreviewViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-27.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class CapturePreviewViewController: UIViewController {

    // MARK: - Variables
    
    var photo: UIImage!
    var videoURL: URL!
    
    var pause = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var audioButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showPreview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playControl()
    }
    
    // MARK: - Functions
    
    func showPreview() {
        if photo != nil { // show photo
            previewImageView.isHidden = false
            audioButton.isHidden = true
            previewImageView.image = photo
        }
        else if videoURL != nil { // show video
            previewImageView.isHidden = true
            audioButton.isHidden = false
            VideoService.createAVPlayerLayer(on: previewView, with: videoURL!)
            VideoService.player.isMuted = true
        }
    }
    
    func playControl() {
        if videoURL != nil {
            switch pause  {
            case 0:
                pause = 1
                VideoService.player.pause()
                SVProgressHUD.show(UIImage(named: "pause")!, status: nil)
                SVProgressHUD.dismiss(withDelay: 1)
                
            case 1:
                pause = 0
                VideoService.player.play()
                SVProgressHUD.show(UIImage(named: "play")!, status: nil)
                SVProgressHUD.dismiss(withDelay: 1)
                
            default:
                break
            }
        }
    }
    
    func audioControl() {
        if videoURL != nil {
            if audioButton.tag == 0 { // sound off
                audioButton.tag = 1
                VideoService.player.isMuted = false
                audioButton.setImage(UIImage(named: "sound_on"), for: .normal)
            }
            else if audioButton.tag == 1 { // sound on
                audioButton.tag = 0
                VideoService.player.isMuted = true
                audioButton.setImage(UIImage(named: "sound_off"), for: .normal)
            }
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
        if VideoService.player != nil {
            VideoService.player.pause()
        }
        performSegue(withIdentifier: "unwind", sender: nil)
//        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func audioButtonPressed(_ sender: UIButton) {
        audioControl()
    }
    
    
}
