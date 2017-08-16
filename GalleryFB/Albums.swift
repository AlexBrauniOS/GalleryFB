//
//  Album.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import Foundation

struct Albums {
    
    let albumName: String
    let albumCoverUrlString: String
    init(albumName: String, albumCoverUrlString: String) {
        self.albumName = albumName
        self.albumCoverUrlString = albumCoverUrlString
    }
    
    init(map: [String : Any]) {
        let name = map["name"] as! String
        let cover = map["picture"] as! [String : Any]
        let coverData = cover["data"] as! [String : Any]
        let urlString = coverData["url"] as! String
        albumName = name
        albumCoverUrlString = urlString
    }
    
}
