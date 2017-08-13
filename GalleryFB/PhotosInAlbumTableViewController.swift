//
//  PhotosInAlbumTableViewController.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin

class PhotosInAlbumTableViewController: UITableViewController {

    var dict: [String: AnyObject]!
    var photos = [Photos]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var album: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfile()
    }
    
    func fetchProfile() {
        print("fetch profile photos")
        
        let parameters = ["fields" : "name,photos{images}"]
        FBSDKGraphRequest(graphPath: "me/albums", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                
                self.dict = resultJSON as! [String : AnyObject]
//                print(resultJSON)
                
                let albums = self.dict["data"] as! [[String : Any]]
//                print(albums)
                
                for album in albums {
                    let name = album["name"] as! String
                    if name == self.album {
                        print(name)
                        let photos = album["photos"] as! [String : Any]
//                        print(photos["data"])
                        let photosData = photos["data"] as! [[String : Any]]
//                        print(photosData)
                        
                        for photo in photosData {
//                            print(photo)
                            let images = photo["images"] as! [[String : Any]]
                            
//                            print(images)
                            for image in images {
                                print(image)
                                let urlString = image["source"] as! String
                                let url = URL.init(string: urlString)
                                let data = try! Data.init(contentsOf: url!)
                                let picture = UIImage.init(data: data)
                                let model = Photos(photo: picture!)
                                self.photos.append(model)
                            }
//                            let image = images["source"] as! [String : Any]
//                            print(image)
                        }
                        
                    }
//                    print(name)
                }
            
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell

        let photo = photos[indexPath.row]
        
        cell.photoImage.image = photo.photo
        
        return cell
    }

}
