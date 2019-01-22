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
    
    
    static func threeCellPerRowStyle(view: UIView, lineSpacing: CGFloat, itemSpacing: CGFloat, inset: CGFloat, heightMultiplier: CGFloat) -> UICollectionViewFlowLayout {
        let cellWidth = (view.frame.size.width - (itemSpacing * 4)) / 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * heightMultiplier)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        return layout
    }
}
