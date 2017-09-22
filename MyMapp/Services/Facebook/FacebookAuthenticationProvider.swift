//
//  FacebookAuthenticationProvider.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import KeychainAccess
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

import Firebase


class FacebookAuthenticationProvider: AuthenticationProviding {
    
    var loginViewController: UIViewController?
    var keychain: Keychain
    var fbLoginManager: FBSDKLoginManager?
    var delegate: AuthenticationManagerDelegate
    
    let provider = AuthenticationProviderName.Facebook
    
    required init(keychain: Keychain, auth delegate: AuthenticationManagerDelegate) {
        self.keychain = keychain
        self.delegate = delegate
    }
    
    var isAuthenticated: Bool {
        get {
            let loggedIn = FBSDKAccessToken.current() != nil
            return self.isInSession && loggedIn
        }
    }
    
    var isInSession: Bool {
        get {
            return self.keychain[provider.rawValue] != nil
        }
    }
    
    func reloadSession() {
        if FBSDKAccessToken.current() != nil {
            self.completeStartSession()
        }
    }
    
    func endSession() {
        if self.fbLoginManager == nil {
            self.fbLoginManager = FBSDKLoginManager()
        }
        self.fbLoginManager?.logOut()
        self.keychain[provider.rawValue] = nil
        
        //TODO: Added to support Firebase
        self.firebaseLogout()
    }
    
    func startSession() {
        
        if FBSDKAccessToken.current() != nil {
            self.completeStartSession()
        } else {
            if self.fbLoginManager == nil {
                self.fbLoginManager = FBSDKLoginManager()
            }
            
            self.fbLoginManager?.logIn(withReadPermissions: ["public_profile"], from: self.loginViewController) {
                (result, error) -> Void in
                
                if let error = error {
                    self.delegate.sessionDidFail(with: error)
                } else if result!.isCancelled {
                    //Do nothing
                } else {
                    self.completeStartSession()
                }
            }
        }
    }
    
    private func completeStartSession() {
        self.keychain[provider.rawValue] = "YES"
        self.delegate.sessionWillStart(with: self)
        self.delegate.completeLogin(["graph.facebook.com" : FBSDKAccessToken.current().tokenString as NSString])
        
        
        //TODO: Added to support Firebase
        self.firebaseLogin()
    }
    
    private func firebaseLogout() {
        try! Auth.auth().signOut()
    }
    
    private func firebaseLogin() {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
        let _ = request?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //FACEBOOK DATA IN DICTIONARY
            let userData = result as! NSDictionary
            User.sharedUser.facebookID = FBSDKAccessToken.current().userID
            User.sharedUser.name = userData.value(forKey: "name") as! String!;
            Auth.auth().signIn(with: credential) { (user, error) in
                FireBaseSynchroniser.sharedSynchroniser.add(user: User.sharedUser.name, service: .Facebook) {
                }
            }
        })
    }
}

