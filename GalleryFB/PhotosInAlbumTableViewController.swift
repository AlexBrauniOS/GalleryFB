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

    var album: String!
    var dict: [String: AnyObject]!
    var photos = [Photos]() {
        didSet{
            stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfile()
        startActivityIndicator()
        setup()
    }
    
    // MARK: - Get data func
    
    func fetchProfile() {
        print("fetch profile photos")
        
        let parameters = ["fields" : "name,photos{images}"]
        FBSDKGraphRequest(graphPath: "me/albums", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                
                self.dict = resultJSON as! [String : AnyObject]
                let albums = self.dict["data"] as! [[String : Any]]
                
                for album in albums {
                    let name = album["name"] as! String
                    if name == self.album {
                        print(name)
                        let photos = album["photos"] as! [String : Any]
                        let photosData = photos["data"] as! [[String : Any]]
                        
                        for photo in photosData {
                            let images = photo["images"] as! [[String : Any]]
                            let bigImages = images[0]
                            let image = bigImages["source"] as! String
                            print(image)
                            let url = URL.init(string: image)
                            kBgQ.async {
                                let data = try! Data.init(contentsOf: url!)
                                let picture = UIImage.init(data: data)
                                let model = Photos(photo: picture!)
                                kMainQueue.async {
                                    self.photos.append(model)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Activity indicator
    
    var activityIndicator = UIActivityIndicatorView()
    
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.navigationItem.title = self.album
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        let photoView = photo.photo
        
        performSegue(withIdentifier: "PhotoViewController", sender: photoView)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoViewController" {
            if let controller = segue.destination as? PhotoViewController,
                let photoView = sender as? UIImage {
                
                controller.image = photoView
            }
        }
    }
}
