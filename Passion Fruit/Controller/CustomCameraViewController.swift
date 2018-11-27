//
//  CustomCameraViewController.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-26.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class CustomCameraViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var previewView: UIView!
    
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
    
    
    // MARK: - Functions
    
    func setUp() {
        flashModeStackView.isHidden = true
        captureModeStackView.isHidden = true
    }
    
    
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    @IBAction func flashButtonPressed(_ sender: UIButton) {
    }
    @IBAction func fleshAutoButtonPressed(_ sender: Any) {
    }
    @IBAction func fleshOnButtonPressed(_ sender: UIButton) {
    }
    @IBAction func fleshOffButtonPressed(_ sender: UIButton) {
    }
    @IBAction func switchCameraButtonPressed(_ sender: UIButton) {
    }
    @IBAction func photoModeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func videoModeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func captureButtonPressed(_ sender: UIButton) {
    }
    
}
