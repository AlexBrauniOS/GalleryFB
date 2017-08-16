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
import Alamofire
import AlamofireImage

class PhotosInAlbumTableViewController: UITableViewController {

    public var albumName: String!
    var dict: [String : AnyObject]!
    var photos:[String] = [] {
        didSet{
            stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        startActivityIndicator()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ImageDownloader.shared.stopRequests()
    }
    
    // MARK: - Get data func
    
    func fetchPhotos() {
        
        let parameters = ["fields" : "name,photos{images}"]
        FBSDKGraphRequest(graphPath: "me/albums", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                
                self.dict = resultJSON as! [String : AnyObject]
                let albums = self.dict["data"] as! [[String : Any]]
                
                for album in albums {
                    let name = album["name"] as! String
                    if name == self.albumName {
                    self.photos.append(contentsOf: Photos(map: album).photoUrlString)
                
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
        self.navigationItem.title = self.albumName
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell

        let photo = photos[indexPath.row]
        cell.photoUrl = photo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        let photoView = photo
        
        performSegue(withIdentifier: "PhotoViewController", sender: photoView)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoViewController" {
            if let controller = segue.destination as? PhotoViewController,
                let photoView = sender as? String {
                
                controller.image = photoView
            }
        }
    }
}
