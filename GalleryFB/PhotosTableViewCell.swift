//
//  PhotosTableViewCell.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    
    var photoUrl: String? {
        didSet{
            ImageDownloader.shared.downloadImages(url: photoUrl!) { image in
                self.photoImage.image = image   
            }
        }
    }
    
}
