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
        getLoginButton()       
    }
    
    func getLoginButton() {
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    // MARK: - Login/Logout button
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")

        if (error != nil){
            print(error.localizedDescription)
        }
        
        if let userToken = result.token{
            let token: FBSDKAccessToken = userToken
            print(token)
            print("TOKEN IS \(FBSDKAccessToken.current().tokenString)")
            print("USER ID IS \(FBSDKAccessToken.current().userID)")
            
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
            self.present(navigationController!, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

