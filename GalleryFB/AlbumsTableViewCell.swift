//
//  AlbumsTableViewCell.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumCoverImage: UIImageView!
    
    var album: Albums? {
        didSet{
            albumNameLabel.text = album?.albumName
            ImageDownloader.shared.downloadImages(url: album!.albumCoverUrlString) { image in
                self.albumCoverImage.image = image
                self.albumCoverImage.layer.cornerRadius = self.albumCoverImage.frame.height/2
                self.albumCoverImage.clipsToBounds = true
            }
        }
    }

}
