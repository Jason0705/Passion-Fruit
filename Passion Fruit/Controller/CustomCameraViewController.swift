//
//  CustomCameraViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-26.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import CameraManager

class CustomCameraViewController: UIViewController {

    // MARK: - Varialbes
    
    let defaults = UserDefaults.standard
    let cameraManager = CameraManager()
    
    var captureMode = 0
    
    var myPhoto: UIImage?
    var myVideoURL: URL?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var flashModeStackView: UIStackView!
    @IBOutlet weak var captureModeStackView: UIStackView!
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set UI State
        setUp()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customCameraToCapturePreviewVC" {
            let destinationVC = segue.destination as! CapturePreviewViewController
            destinationVC.photo = myPhoto
            destinationVC.videoURL = myVideoURL
        }
    }
    
    
    // MARK: - Functions
    
    func setUp() {
        changeFlashMode(to: defaults.integer(forKey: "CameraFlashMode"))
        changeCaptureMode(to: 0)
        captureModeStackView.isHidden = true
        cameraManager.addPreviewLayerToView(cameraView)
        addLongPressGesture(to: captureButton)
    }
    
    func addLongPressGesture(to button: UIButton){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(captureButtonLongPressed(gesture:)))
        longPress.minimumPressDuration = 1
        button.addGestureRecognizer(longPress)
    }
    
    func changeFlashMode(to mode: Int) {
        if mode == 0 { // off
            cameraManager.flashMode = .off
            flashButton.setImage(UIImage(named: "flash_off_filled"), for: .normal)
        }
        else if mode == 1 { // on
            cameraManager.flashMode = .on
            flashButton.setImage(UIImage(named: "flash_on_filled"), for: .normal)
        }
        else if mode == 2 { // auto
            cameraManager.flashMode = .auto
            flashButton.setImage(UIImage(named: "flash_auto_filled"), for: .normal)
        }
        
        defaults.set(mode, forKey: "CameraFlashMode")
        flashModeStackView.isHidden = true
    }
    
    func changeCameraDevice() {
        if switchCameraButton.tag == 0 { // currently on back cam
            cameraManager.cameraDevice = .front
            switchCameraButton.tag = 1
        }
        else if switchCameraButton.tag == 1 { // currently on front cam
            cameraManager.cameraDevice = .back
            switchCameraButton.tag = 0
        }
    }
    
    @objc func captureButtonLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            captureModeStackView.isHidden = false
        }
    }
    
    func changeCaptureMode(to mode: Int) {
        if mode == 0 { // photo
            cameraManager.cameraOutputMode = .stillImage
            captureButton.setImage(nil, for: .normal)
        }
        else if mode == 1 { // video
            cameraManager.cameraOutputMode = .videoWithMic
            captureButton.setImage(UIImage(named: "record_filled"), for: .normal)
        }
        captureMode = mode
        captureModeStackView.isHidden = true
    }
    
    func capture() {
        if captureMode == 0 { // photo mode
            captureButton.tag = 0
            cameraManager.capturePictureWithCompletion { (image, error) in
                if error != nil {
                    print("Error taking photo: \(error!)")
                    return
                }
                self.myPhoto = image
                self.myVideoURL = nil
                self.performSegue(withIdentifier: "customCameraToCapturePreviewVC", sender: self)
            }
        }
        else if captureMode == 1 { // video mode
            if captureButton.tag == 0 { // not recording
                captureButton.tag = 1
                cameraManager.startRecordingVideo()
                captureButton.setImage(UIImage(named: "stop_filled"), for: .normal)
            }
            else if captureButton.tag == 1 { // recording
                captureButton.tag = 0
                cameraManager.stopVideoRecording { (url, error) in
//                    do {
//                        try FileManager.default.copyItem(at: url ??, to: self.myVideoURL)
//                        print("stop recording!!!!!!!!111111111")
//                    }
//                    catch {
//                        print("Error recording video: \(error)")
//                    }
                    self.myVideoURL = url
                    self.myPhoto = nil
                    self.performSegue(withIdentifier: "customCameraToCapturePreviewVC", sender: self)
                }
                captureButton.setImage(UIImage(named: "record_filled"), for: .normal)
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func flashButtonPressed(_ sender: UIButton) {
        flashModeStackView.isHidden = false
    }
    
    @IBAction func fleshAutoButtonPressed(_ sender: Any) {
        changeFlashMode(to: 2)
    }
    
    @IBAction func fleshOnButtonPressed(_ sender: UIButton) {
        changeFlashMode(to: 1)
    }
    
    @IBAction func fleshOffButtonPressed(_ sender: UIButton) {
        changeFlashMode(to: 0)
    }
    
    @IBAction func switchCameraButtonPressed(_ sender: UIButton) {
        changeCameraDevice()
    }
    
    @IBAction func photoModeButtonPressed(_ sender: UIButton) {
        changeCaptureMode(to: 0)
    }
    @IBAction func videoModeButtonPressed(_ sender: UIButton) {
        changeCaptureMode(to: 1)
    }
    
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        capture()
        
//        if myPhoto != nil || myVideoURL != nil {
//            performSegue(withIdentifier: "customCameraToCapturePreviewVC", sender: self)
//        }
    }
    
    
    
}
