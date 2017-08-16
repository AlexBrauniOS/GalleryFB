//
//  PhotoViewController.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var fullImage: UIImageView!
    
    var image: String? {
        didSet{
            ImageDownloader.shared.downloadImages(url: image!) { image in
                self.fullImage.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
