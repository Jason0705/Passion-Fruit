//
//  CustomizationService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-10.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit

class CustomizationService {
    
    static func textFieldUnderline(textField: UITextField) {
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 0.6)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        textField.layer.addSublayer(bottomLayer)
    }
    
    
    func threeCellPerRowStyle(view: UIView, spacing: CGFloat, inset: UIEdgeInsets, heightMultiplier: CGFloat) -> UICollectionViewFlowLayout {
        let cellSize = (view.frame.size.width - (spacing * 4)) / 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = inset
        layout.itemSize = CGSize(width: cellSize, height: cellSize * heightMultiplier)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        return layout
    }
}
