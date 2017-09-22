//
//  TwitterAuthenticationProvider.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import TwitterKit
import KeychainAccess


class TwitterAuthenticationProvider: AuthenticationProviding {
    
    
    var loginViewController: UIViewController?
    var keychain: Keychain
    var delegate: AuthenticationManagerDelegate
    
    let provider = AuthenticationProviderName.Twitter
    
    required init(keychain: Keychain, auth delegate: AuthenticationManagerDelegate) {
        self.keychain = keychain
        self.delegate = delegate
    }
    
    var isAuthenticated: Bool {
        get {
            let loggedIn = Twitter.sharedInstance().session() != nil
            return isInSession && loggedIn
        }
    }
    
    var isInSession: Bool {
        get {
            return self.keychain[provider.rawValue] != nil
        }
    }

    func startSession() {
        print("Logging into Twitter")
        Twitter.sharedInstance().logIn { (session, error) -> Void in
            if session != nil {
                self.completeSession()
            } else if let error = error {
                self.delegate.sessionDidFail(with: error)
            } else {
                let error = NSError(domain: "com.bjss.AuthenticationProvider", code: 30001, userInfo: [NSLocalizedDescriptionKey:"TwitterAuthenticationProvider"])
                self.delegate.sessionDidFail(with: error)
            }
        }
    }

    func reloadSession() {
        startSession()
    }
    
    func endSession() {
        Twitter.sharedInstance().logOut()
        self.keychain[provider.rawValue] = nil
    }
    
    private func completeSession() {
        self.keychain[provider.rawValue] = "YES"
        self.delegate.sessionWillStart(with: self)
        self.delegate.completeLogin(["api.twitter.com": self.loginForTwitterSession(Twitter.sharedInstance().session()!) as NSString])
    }
    
    private func loginForTwitterSession(_ session: TWTRAuthSession) -> String {
        return session.authToken + ";" + session.authTokenSecret
    }
}
