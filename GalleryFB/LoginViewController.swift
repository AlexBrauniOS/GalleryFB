//
//  ViewController.swift
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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["user_photos"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current() != nil) {
            print("current token")
            fetchProfile()
        }
    }
    
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields" : "email, first_name"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                 print(error!)
                return
            }

            print(result)
            
//            if let email = result["email"] as? String {
//                print(email)
//            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
        if (error != nil){
            print(error.localizedDescription)
        }
        
        if let userToken = result.token{
            // GET USER TOKEN HERE
            let token:FBSDKAccessToken = userToken
            print(token)
            //print token id and user id
            print("TOKEN IS \(FBSDKAccessToken.current().tokenString)")
            print("USER ID IS \(FBSDKAccessToken.current().userID)")
            
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func setup() {
        
    }
    
    
    @IBAction func getData(_ sender: UIButton) {
       setup()
        
    }
}
