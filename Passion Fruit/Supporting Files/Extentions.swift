//
//  Extentions.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-12-28.
//  Copyright © 2018 Jason Li. All rights reserved.


import UIKit

extension UIView {
    
//    func createLabelView(title: String, body: String, at origin: CGPoint) {
//        let labelView = UIView()
//        labelView.frame.origin = origin
//        labelView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        labelView.createProfileLabelWithTitle(title: title, body: body)
//        labelView.addUnderline()
//        self.addSubview(labelView)
//    }
    
    func createProfileLabelWithTitle(title labelTitle: String, body labelBody: String) -> CGFloat {
        
        let title = UILabel()
        let body = UILabel()
        
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width / 3 - 7, height: 30)
        title.textAlignment = .left
        title.textColor = UIColor.black
        title.text = labelTitle
//        title.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.sizeToFit()
        self.addSubview(title)
        
        body.frame = CGRect(x: 0 + (self.frame.width / 3) + 7, y: 0, width: self.frame.width / 3 * 2 - 7, height: 30)
        body.textAlignment = .left
        body.textColor = UIColor.black
        body.text = labelBody
        body.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        body.numberOfLines = 0
        body.lineBreakMode = NSLineBreakMode.byWordWrapping
        body.sizeToFit()
        self.addSubview(body)
        
        return CGFloat.maximum(title.frame.height, body.frame.height)
        
    }
    
    func addUnderline() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height + 8, width: self.frame.width, height: 0.6)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(bottomLayer)
    }
}


////let imageCache = NSCache<AnyObject, AnyObject>()
//
//
//class Cache {
//    func clearCache() {
//        imageCache.removeAllObjects()
//        print("CACHE CLEARED")
//    }
//}
//
//
//extension UIImageView {
//    
//    func loadImageUsingCacheWithURL(urlString: String) {
//        
//        self.image = nil
//        
//        // check cache for image first
//        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = cachedImage
//            return
//        }
//        
//        // otherwise download
//        if let url = URL(string: urlString) {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                
//                // download error, return out
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    
//                    if let downloadedImage = UIImage(data: data!) {
//                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject) as? UIImage
//                        
//                        self.image = downloadedImage
//                    }
//                    
//                }
//                
//                }.resume()
//        }
//    }
//    
//}
