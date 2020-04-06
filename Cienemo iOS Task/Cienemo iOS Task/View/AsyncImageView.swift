//
//  AsyncImageView.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/5/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSURL,UIImage>()

class AsyncImageView: UIImageView {

    var imageUrl: URL?
    
    func loadImageUsingUrlString(url: URL, size: CGSize) {
        imageUrl = url
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            self.image = imageFromCache
            return
        }
    
        DispatchQueue.global(qos: .userInitiated).async {
            let imageToCache = self.resizedImage(at: url, for: size)
            
            DispatchQueue.main.async {
                if self.imageUrl == url {
                    self.image = imageToCache
                }
                
                if let imageToCache = imageToCache {
                    imageCache.setObject(imageToCache, forKey: url as NSURL)
                }
            }
        }
    }
    
    private func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
