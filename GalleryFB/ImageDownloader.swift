//
//  NetworkManager.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 16.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    var dict: [String : AnyObject]!
    
    func downloadImages(url: String, completion: @escaping (UIImage)->()) {
        let url = URL.init(string: url)
        if let url = url {
            Alamofire.request(url).responseImage { (response) in
                if let value = response.result.value {
                    let image = value
                    completion(image)
                }
            }
        }
    }
    
    func stopRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }

}
