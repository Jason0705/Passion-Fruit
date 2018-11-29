//
//  CustomCameraViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-26.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import CameraManager
import SVProgressHUD

class CustomCameraViewController: UIViewController {

    // MARK: - Varialbes
    
    let defaults = UserDefaults.standard
    let cameraManager = CameraManager()
    
    var videoEnabled = true
    
    var captureMode = 0
    
    var myPhoto: UIImage?
    var myVideoURL: URL?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var flashModeStackView: UIStackView!
    @IBOutlet weak var captureModeStackView: UIStackView!
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set UI State
        setUp()
        print("\(videoEnabled)")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        flashModeStackView.isHidden = true
        captureModeStackView.isHidden = true
    }
    
    
    
    // MARK: - Functions
    
    func setUp() {
        changeFlashMode(to: defaults.integer(forKey: "CameraFlashMode"))
//        changeCaptureMode(to: 0)
        captureModeStackView.isHidden = true
        cameraManager.addPreviewLayerToView(cameraView)

        if videoEnabled == true {
            addLongPressGesture(to: captureButton)
            addSwipeGesture(to: captureButton)
        }
    }
    
    // Handle gestures
    func addLongPressGesture(to button: UIButton) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(captureButtonLongPressed(gesture:)))
        longPress.minimumPressDuration = 1
        button.addGestureRecognizer(longPress)
    }
    
    func addSwipeGesture(to button: UIButton) {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        button.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        button.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.left || gesture.direction == UISwipeGestureRecognizer.Direction.right {
            if captureMode == 0 { // currently photo
                changeCaptureMode(to: 1)
            }
            else if captureMode == 1 { // currently video
                changeCaptureMode(to: 0)
            }
        }
    }
    
    
    // Camera mode functions
    
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
    
    func changeLocationService() {
        if locateButton.tag == 0 { // currently off
            locateButton.tag = 1
            cameraManager.shouldUseLocationServices = true
            locateButton.setImage(UIImage(named: "locate_me_filled"), for: .normal)
            SVProgressHUD.show(UIImage(named: "locate_me_filled")!, status: "Location Service: ON")
            SVProgressHUD.dismiss(withDelay: 1)
            
        }
        else if locateButton.tag == 1 { // currently on
            locateButton.tag = 0
            cameraManager.shouldUseLocationServices = false
            locateButton.setImage(UIImage(named: "locate_me"), for: .normal)
            SVProgressHUD.show(UIImage(named: "locate_me")!, status: "Location Service: OFF")
            SVProgressHUD.dismiss(withDelay: 1)
        }
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
            SVProgressHUD.show(UIImage(named: "camera")!, status: nil)
            SVProgressHUD.dismiss(withDelay: 1)
        }
        else if mode == 1 { // video
            cameraManager.cameraOutputMode = .videoWithMic
            captureButton.setImage(UIImage(named: "record_filled"), for: .normal)
            SVProgressHUD.show(UIImage(named: "video")!, status: nil)
            SVProgressHUD.dismiss(withDelay: 1)
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
    
    @IBAction func locateButtonPressed(_ sender: UIButton) {
        changeLocationService()
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
