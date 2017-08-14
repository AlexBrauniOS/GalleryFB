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

let kBgQ = DispatchQueue.global(qos: .background)
let kMainQueue = DispatchQueue.main

class AlbumsTableViewController: UITableViewController {
    
    var dict: [String: AnyObject]!
    var albums = [Albums]() {
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
            fetchProfile()
        } else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Get data func
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields" : "albums{name,picture}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                self.dict = resultJSON as! [String : AnyObject]
                let albums = self.dict["albums"]?["data"] as! [[String : Any]]
                
                for album in albums {
                    let name = album["name"] as! String
                    let cover = album["picture"] as! [String : Any]
                    let coverData = cover["data"] as! [String : Any]
                    let urlString = coverData["url"] as! String
                    let url = URL.init(string: urlString)
                    kBgQ.async {
                        let data = try! Data.init(contentsOf: url!)
                        let picture = UIImage.init(data: data)
                        let model = Albums(albumName: name, albumCover: picture!)
                        kMainQueue.async {
                            self.albums.append(model)
                        }
                        
                    }
                }
            } else {
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
        
        cell.albumNameLabel.text = album.albumName
        cell.albumCoverImage.image = album.albumCover
        
        cell.albumCoverImage.layer.cornerRadius = cell.albumCoverImage.frame.height/2
        cell.albumCoverImage.clipsToBounds = true
        
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
                
                controller.album = nameOfAlbum
            }
        }
    }
}
