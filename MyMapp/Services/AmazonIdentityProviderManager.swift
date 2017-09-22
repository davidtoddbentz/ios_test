//
//  AmazonIdentityProviderManager.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 08/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class AmazonIdentityProviderManager: NSObject, AWSIdentityProviderManager {
  
  static let sharedInstance = AmazonIdentityProviderManager()
  fileprivate var loginCache = NSMutableDictionary()
  
  @objc func logins() -> AWSTask<NSDictionary> {

    return AWSTask(result: loginCache)
  }
  
  func reset() {
    self.loginCache = NSMutableDictionary()
  }
  
  func mergeLogins(_ logins: NSMutableDictionary?) {
    var merge = NSMutableDictionary()
    merge = loginCache
    //Add new logins
    if let unwrappedLogins = logins {
      for (key, value) in unwrappedLogins {
        merge[key] = value
      }
      self.loginCache = merge
    }
  }
}
