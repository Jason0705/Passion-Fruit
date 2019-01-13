//
//  Extentions.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-12-28.
//  Copyright © 2018 Jason Li. All rights reserved.


import UIKit

extension UILabel {
    func createProfileLabel(with labelText: String, on view: UIView, lastElementOnView: UILabel, verticalSpacing: CGFloat) {
        let label = UILabel()
        label.frame = CGRect(x: lastElementOnView.frame.origin.x, y: lastElementOnView.frame.origin.y + lastElementOnView.frame.height + verticalSpacing, width: lastElementOnView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.text = labelText
        label.sizeToFit()
        view.addSubview(label)
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
