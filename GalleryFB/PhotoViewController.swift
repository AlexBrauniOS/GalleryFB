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
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.fullImage.image = image
    }

}
