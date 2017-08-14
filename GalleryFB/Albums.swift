//
//  Album.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import Foundation
import UIKit

class Albums {
    
    let albumName: String
    let albumCover: UIImage
    init(albumName: String, albumCover: UIImage) {
        self.albumName = albumName
        self.albumCover = albumCover
    }
}
