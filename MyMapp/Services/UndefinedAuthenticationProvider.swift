//
//  UndefinedAuthenticationProvider.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 23/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import KeychainAccess

class UndefinedAuthenticationProvider: AuthenticationProviding {
    
    var loginViewController: UIViewController?
    var keychain: Keychain
    var delegate: AuthenticationManagerDelegate
    let provider = AuthenticationProviderName.Undefined
    
    internal var isLoggedIn = false
    
    required init(keychain: Keychain, auth delegate: AuthenticationManagerDelegate) {
        self.keychain = keychain
        self.delegate = delegate
    }
    
    var isAuthenticated: Bool {
        get {
            return isInSession && isLoggedIn
        }
    }
    
    var isInSession: Bool {
        get {
            return self.keychain[provider.rawValue] != nil
        }
    }
    
    func startSession() {
        self.keychain[provider.rawValue] = "YES"
        self.delegate.completeLogin(NSMutableDictionary())
        self.isLoggedIn = true
        self.delegate.sessionWillStart(with: self)
    }
    
    func reloadSession() {
        self.startSession()
    }
    
    func endSession() {
        
        self.isLoggedIn = false
        self.keychain[provider.rawValue] = nil
    }
}
