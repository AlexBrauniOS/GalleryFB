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

class AlbumsTableViewController: UITableViewController {

    var dict: [String: AnyObject]!
    var albums = [Albums]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            print("current token")
            
            fetchProfile()
            
        } else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)

        }
    
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields" : "albums{name,picture}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if let resultJSON = result, error == nil {
                self.dict = resultJSON as! [String : AnyObject]
                //                print(resultJSON)
                let albums = self.dict["albums"]?["data"] as! [[String : Any]]
//                    print(albums)
                
                for album in albums {
                    let name = album["name"] as! String
                    let cover = album["picture"] as! [String : Any]
//                    print(cover["data"])
                    let coverData = cover["data"] as! [String : Any]
                    let urlString = coverData["url"] as! String
                    print(urlString)
                    let url = URL.init(string: urlString)
                    let data = try! Data.init(contentsOf: url!)
                    let picture = UIImage.init(data: data)
                    let model = Albums(albumName: name, albumCover: picture!)
                    self.albums.append(model)
                }
//                print(self.albums)
//                print(self.albums[2].albumName)
//                print(self.albums.count)
                print(self.albums[0].albumCover)
                
            } else {
                
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as! AlbumsTableViewCell

        let album = albums[indexPath.row]
        
        cell.albumNameLabel.text = album.albumName
        cell.albumCoverImage.image = album.albumCover
        
    
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
