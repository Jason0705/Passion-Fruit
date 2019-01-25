//
//  ImageService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-01-10.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageService {
    
    func clearCache() {
        imageCache.removeAllObjects()
        print("CACHE CLEARED")
    }
    
    static func getImageUsingCacheWithURL(urlString: String) -> UIImage {
        
        var image = UIImage()
        
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
            return image
        }
        
        // otherwise download
        if let url = URL(string: urlString), let data = NSData(contentsOf: url) {
            
            if let downloadedImage = UIImage(data: data as Data) {
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject) as? UIImage
                
                image = downloadedImage
                
                return image
            }
        }
        
        return image
        
    }
    
}
