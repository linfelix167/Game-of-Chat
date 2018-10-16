//
//  UIImageViewExtension.swift
//  Game of Chat
//
//  Created by Felix Lin on 10/16/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        self.image = nil
        
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // new download
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            // download hit error
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
