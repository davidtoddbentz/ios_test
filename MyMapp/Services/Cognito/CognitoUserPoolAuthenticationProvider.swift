//
//  CognitoUserPoolAuthenticationProvider.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import KeychainAccess
import AWSCognito
import AWSCognitoIdentityProvider
import Firebase

class CognitoUserPoolAuthenticationProvider: CredentialAuthenticationProviding {
    
    let provider = AuthenticationProviderName.Cognito
    let userpool: String = "UserPool"
    var loginViewController: UIViewController?
    var keychain: Keychain
    var delegate: AuthenticationManagerDelegate
    var userPreference: UserPreferences?
    
    func startSession() {
        if let userPreference = self.userPreference {
            userPreference.getUserCredential({ (username, password) in
                self.startSession(username: username, password: password)
            })
        }
    }
    
    required init(keychain: Keychain, auth delegate: AuthenticationManagerDelegate) {
        self.keychain = keychain
        self.delegate = delegate
        self.userPreference = UserPreferences.sharedManager
    }
    
    func reloadSession() {
        self.startSession()
    }
    
    
    var isAuthenticated: Bool {
        get {
            let userPool = AWSCognitoIdentityUserPool(forKey: self.userpool)
            let value = self.isInSession && (userPool.currentUser()?.isSignedIn ?? false)
            return value
        }
    }
    
    var isInSession: Bool {
        get {
            return self.keychain[provider.rawValue] != nil
        }
    }

    internal func startSession(username: String, password: String) {

        let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        let user = userPool.getUser(username)
        user.getSession(username, password: password, validationData: nil).continueWith(executor: AWSExecutor.mainThread(), block: {
            (task: AWSTask!) -> AnyObject! in
            
            if task.isCancelled {
                
            } else if let error = task.error {
        
                self.delegate.sessionDidFail(with: error)
                
            } else {
                
                let providerId = "cognito-idp.us-east-1.amazonaws.com/\(Constants.CognitoIdentityUserPoolId)"
                let userSession = task.result
                let token = userSession?.idToken?.tokenString ?? ""
                self.keychain[self.provider.rawValue] = providerId
                self.delegate.sessionWillStart(with: self)
                self.delegate.completeLogin([providerId:token])
                //TODO: Remove Firebase Support
                self.firebaseLogin()
            }
            return nil
        })
        
    }
    
    func endSession() {

        let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        userPool.currentUser()?.signOutAndClearLastKnownUser()
        self.keychain[provider.rawValue] = nil
        //TODO: Remove Firebase Support
        self.firebaseLogout()
    }
    
    private func firebaseLogout() {
        try! Auth.auth().signOut()
    }
    
    private func firebaseLogin() {
        
        let email = "ascuderi.bjss@gmail.com"
        let password = "Password1!"
        
        User.sharedUser.facebookID = email
        User.sharedUser.name = "Test";
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            FireBaseSynchroniser.sharedSynchroniser.add(user: User.sharedUser.name, service: .Facebook) {
            }
        }
        
    }

}
