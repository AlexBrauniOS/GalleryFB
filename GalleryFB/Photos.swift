//
//  Photos.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import Foundation

class Photos {
    
    var photoUrlString: [String] = []
    init(photoUrlString: [String]) {
        self.photoUrlString = photoUrlString
    }
    
    init(map: [String : Any]) {
            let photos = map["photos"] as! [String : Any]
            let photosData = photos["data"] as! [[String : Any]]
            var newArray:[String] = []
            for photo in photosData {
                let images = photo["images"] as! [[String : Any]]
                let bigImages = images[0]
                let image = bigImages["source"] as! String
                    newArray.append(image)
            }
            self.photoUrlString = newArray
        }
    
}
