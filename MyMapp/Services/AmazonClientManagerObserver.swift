//
//  AmazonClientManagerObserver.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 08/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

@objc protocol AmazonClientManagerObserver {
  
  func amazonClientManagerDidLogin()
  func amazonClientManagerDidFailLogin(_ notification: Notification)
  func amazonClientManagerDidLogout()
}

enum AmazonClientManagerNotification: String {
  
  case AmazonClientManagerDidLogin
  case AmazonClientManagerDidFailLogin
  case AmazonClientManagerDidLogout
}

extension AmazonClientManager {
  
  func addObserver(_ observer: AmazonClientManagerObserver) {
    self.addObserver(.AmazonClientManagerDidLogin, observer: observer)
    self.addObserver(.AmazonClientManagerDidLogout, observer: observer)
    self.addObserver(.AmazonClientManagerDidFailLogin, observer: observer)
    
  }
  
  func removeObserver(_ observer: AmazonClientManagerObserver) {
    self.removeObserver(.AmazonClientManagerDidLogout, observer: observer)
    self.removeObserver(.AmazonClientManagerDidLogin, observer: observer)
    self.removeObserver(.AmazonClientManagerDidFailLogin, observer: observer)
  }
  
  func addObserver(_ name: AmazonClientManagerNotification, observer: AmazonClientManagerObserver) {
    
    switch name {
    case .AmazonClientManagerDidLogout:
      let selector = #selector(observer.amazonClientManagerDidLogout)
      NotificationCenter.default.addObserver(observer, selector:selector, name: NSNotification.Name(rawValue: name.rawValue), object: nil)
    case .AmazonClientManagerDidLogin:
      let selector = #selector(observer.amazonClientManagerDidLogin)
      NotificationCenter.default.addObserver(observer, selector:selector, name: NSNotification.Name(rawValue: name.rawValue), object: nil)
    case .AmazonClientManagerDidFailLogin:
      let selector = #selector(observer.amazonClientManagerDidFailLogin(_:))
      NotificationCenter.default.addObserver(observer, selector:selector, name: NSNotification.Name(rawValue: name.rawValue), object: nil)
    }
  }
  
  func removeObserver(_ name: AmazonClientManagerNotification, observer: AmazonClientManagerObserver) {
    NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name.rawValue), object: nil)
  }
  
  func postNotification(_ name: AmazonClientManagerNotification, userInfo: [AnyHashable: Any]?) {
    let notification = Notification(name: Notification.Name(rawValue: name.rawValue), object: nil, userInfo: userInfo)
    NotificationCenter.default.post(notification)
  }

}
