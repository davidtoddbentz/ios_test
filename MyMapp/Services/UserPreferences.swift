//
//  UserPreferences.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 14/07/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import KeychainAccess
import AWSCognito
import AWSCognitoIdentityProvider

class UserPreferences {
  
  static let sharedManager = UserPreferences()
  
  var username: String {
    get {
      return self.keychain[keyUsername] ?? ""
    }
    set {
      self.keychain[keyUsername] = newValue
    }
  }
  
  let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
  
  fileprivate let keyTouchID = "UserPreference.isTouchIdEnabled"
  fileprivate let keyUsername = "UserPreference.username"
  
  init() {
    
    let myKey = UserDefaults.standard.object(forKey: keyTouchID)
    if myKey == nil {
      NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeSettings(sender:)), name: UserDefaults.didChangeNotification, object: nil)
      UserDefaults.standard.set(false, forKey: keyTouchID)
      UserDefaults.standard.synchronize()
    }
  }
  
  deinit {
     NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
  }
  
  @objc func didChangeSettings(sender: AnyObject?) {
    print("UserDefaults.didChangeNotification")
  }
  
  var isTouchIdEnabled: Bool {
    get {
      return UserDefaults.standard.bool(forKey: keyTouchID)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: keyTouchID)
      UserDefaults.standard.synchronize()
    }
  }

  func isUserCredentialStored() -> Bool {
      return self.username != ""
  }

  func removeUserCredential() {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      do {
        
        //When used for the first time
        if self.isUserCredentialStored() {
          if let user = self.keychain[self.keyUsername], user != "" {
            try self.keychain.remove(user)
            try self.keychain.remove(self.keyUsername)
            print("User credential removed.")
          }
        }
      } catch let error {
        print("Error while removing user credential.")
        print(error)
      }
    }
  }
  
  func getUserCredential(_ completion: @escaping (_ user: String, _ password: String)->()) {
    
    guard self.isUserCredentialStored() else { return }
    
    guard self.isTouchIdEnabled else { return }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      do {
        let password = try self.keychain
          .authenticationPrompt("AuthID: \(self.username)")
          .get(self.username)
        DispatchQueue.main.async(execute: {
          completion(self.username, password!)
        })
      } catch let error {
        // Error handling if needed...
         print(error)
      }
    }
  }
  
  func saveUserCredential(_ user: String?, password: String?, completion: @escaping (_ error: NSError?)->()) {
    
    guard let userString = user else { return }
    guard let passwordString = password else { return }
  
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        do {
          //When used for the first time
          if self.isTouchIdEnabled && !self.isUserCredentialStored() {
          
            
            try self.keychain
            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
            .set(passwordString, key: userString)
            self.username = userString
          }
          completion(nil)
        } catch let error {
          print(error)
          completion(error as NSError)
        }
    }
  }
  
  //S3 Keychain
  
  func synchUserS3Keychain(_ key: String) {
    
    //TODO: Store a key with the S3 password in a user dataset without encryption. THIS COULD BE A SECURITY ISSUE
    
    if self.keychain[key] == nil {
      let syncClient = AWSCognito.default()
      let dataset = syncClient.openOrCreateDataset("S3CredentialDataset")
        dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
        if let password = dataset.string(forKey: key) {
          self.keychain[key] = password
        } else {
          self.keychain[key] = Keychain.generatePassword()
          dataset.setString(self.keychain[key], forKey:key)
            dataset.synchronize().continueWith(block: { (task) -> AnyObject? in
            if let error = task.error {
              print("Unable to store the key on the cloud: \(error.localizedDescription)")
              self.keychain[key] = nil
              print(AmazonClientManager.sharedInstance.credentialsProvider?.identityId)
              return nil
            }
            return nil
          })
        }
        return nil
      })
    }
  }
  
  func resetUserS3Keychain(_ key: String) {
    self.keychain[key] = nil
  }
}
