//
//  LazyImageView.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/11/21.
//

import Foundation
import UIKit

// This is not the perfect way to Imageload as I didn't have time to optimized code to I wrote this, I could have used SDWebImage SDK but as third perty is not allowed so I wrote it
class LazyImageView: UIImageView {
    let cacheImages = NSCache<AnyObject,UIImage>()

    func loadImageAsync(url:String) {
        if let imageData = cacheImages.object(forKey: NSString(string:url)) {
            self.image = imageData
            return
        }
    
        
        WebService().downloadImage(for: url, success: {[weak self] (data) in
            if let data = data, let imageData = UIImage(data:data) {
                self?.cacheImages.setObject(imageData, forKey: NSString(string: url))
                self?.image = imageData
                return
            }
        }, fail: { (error) in
            
        })
    }
}
