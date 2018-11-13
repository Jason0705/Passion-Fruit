//
//  AlertService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-10.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class AlertService: UIViewController {
    
    static var alertService = AlertService()
    
    // Present Error Alert
    func presentErrorAlert(message: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (AlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
