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
    
    func loadImageUsingUrlString(url: URL) {
        imageUrl = url
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    
                    if self.imageUrl == url {
                        self.image = imageToCache
                    }
                    
                    if let imageToCache = imageToCache {
                        imageCache.setObject(imageToCache, forKey: url as NSURL)
                    }
                }
            } catch {
                debugPrint(error)
                return
            }
        }
    }
}
