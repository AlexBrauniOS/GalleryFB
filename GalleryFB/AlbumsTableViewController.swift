//
//  AlbumsTableViewController.swift
//  GalleryFB
//
//  Created by Oleksii Liubarets on 10.08.17.
//  Copyright © 2017 Oleksii Liubarets. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookCore
import FacebookLogin
import Alamofire
import AlamofireImage

class AlbumsTableViewController: UITableViewController {
    
    var dict: [String : AnyObject]!
    var albums: [Albums] = [] {
        didSet {
            stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
        setup()
        if (FBSDKAccessToken.current() != nil) {
            fetchAlbums()
        } else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Get data func
    
    func fetchAlbums() {
        
        let parameters = ["fields" : "albums{name,picture}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                self.dict = resultJSON as! [String : AnyObject]
                let albums = self.dict["albums"]?["data"] as! [[String : Any]]
                
                for album in albums {
                    self.albums.append(Albums(map: album))
                }
            }
        }
    }
    
    // MARK: - Activity Indicator
    
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
    
    func setup() {
        self.navigationItem.title = "My albums"
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as! AlbumsTableViewCell
        
        let album = albums[indexPath.row]
        cell.album = album
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let album = albums[indexPath.row]
        let nameOfAlbum = album.albumName
        
        performSegue(withIdentifier: "PhotosInAlbumTableViewController", sender: nameOfAlbum)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotosInAlbumTableViewController" {
            if let controller = segue.destination as? PhotosInAlbumTableViewController,
                let nameOfAlbum = sender as? String {
                
                controller.albumName = nameOfAlbum
            }
        }
    }
}
