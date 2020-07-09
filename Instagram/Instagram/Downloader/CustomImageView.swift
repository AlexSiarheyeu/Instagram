//
//  CustomImageView.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/4/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        
        if let cache = imageCache[urlString] {
            self.image = cache
            return
        }
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print("Failed to fetch post image", error)
                return
            }

            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }

            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)

            imageCache[url.absoluteString] = photoImage

            DispatchQueue.main.async {
                self.image = photoImage
            }

        }.resume()

    }
}
