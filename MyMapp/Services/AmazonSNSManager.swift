//
//  AmazonSNSManager.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 08/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import AWSSNS
import KeychainAccess

class AmazonSNSManager: NSObject {
  static let sharedInstance = AmazonSNSManager()
  
  var keyChain: Keychain
  
  override init() {
    keyChain = Keychain(service: "\(Bundle.main.bundleIdentifier!).\(AmazonClientManager.self)")
    super.init()
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
    
    // Sets up Mobile Push Notification
    let readAction = UIMutableUserNotificationAction()
    readAction.identifier = "READ_IDENTIFIER"
    readAction.title = "Read"
    readAction.activationMode = UIUserNotificationActivationMode.foreground
    readAction.isDestructive = false
    readAction.isAuthenticationRequired = true
    
    let deleteAction = UIMutableUserNotificationAction()
    deleteAction.identifier = "DELETE_IDENTIFIER"
    deleteAction.title = "Delete"
    deleteAction.activationMode = UIUserNotificationActivationMode.foreground
    deleteAction.isDestructive = true
    deleteAction.isAuthenticationRequired = true
    
    let ignoreAction = UIMutableUserNotificationAction()
    ignoreAction.identifier = "IGNORE_IDENTIFIER"
    ignoreAction.title = "Ignore"
    ignoreAction.activationMode = UIUserNotificationActivationMode.foreground
    ignoreAction.isDestructive = false
    ignoreAction.isAuthenticationRequired = false
    
    let messageCategory = UIMutableUserNotificationCategory()
    messageCategory.identifier = "MESSAGE_CATEGORY"
    messageCategory.setActions([readAction, deleteAction], for: UIUserNotificationActionContext.minimal)
    messageCategory.setActions([readAction, deleteAction, ignoreAction], for: UIUserNotificationActionContext.default)
    
    let notificationTypes: UIUserNotificationType =  [UIUserNotificationType.badge, UIUserNotificationType.sound, UIUserNotificationType.alert]
    let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: (NSSet(array: [messageCategory])) as? Set<UIUserNotificationCategory>)
    
    UIApplication.shared.registerForRemoteNotifications()
    UIApplication.shared.registerUserNotificationSettings(notificationSettings)
   
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    var tokenString = ""
    for i in 0..<deviceToken.count {
        tokenString += String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    print("tokenString: \(tokenString)")
    self.keyChain[Constants.DeviceTokenKey] = tokenString
    
    let userDefaults = UserDefaults.standard
    userDefaults.set(deviceToken, forKey: Constants.DeviceTokenKey)
    userDefaults.synchronize()
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("Failed to register with error: \(error)")
    do {
      try self.keyChain.remove(Constants.DeviceTokenKey)
    } catch {
      
    }
  }
  
  func registerToken(user: String?) {
    
    let sns = AWSSNS.default()
    
    let request = AWSSNSCreatePlatformEndpointInput()
    request?.token = self.keyChain[Constants.DeviceTokenKey]
    request?.platformApplicationArn = Constants.SNSPlatformApplicationArn
    
    sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread()) { (task: AWSTask!) -> AnyObject! in
      if task.error != nil {
        print("Error: \(String(describing: task.error))")
      } else {
        if let createEndpointResponse = task.result {
          print("endpointArn: \(String(describing: createEndpointResponse.endpointArn))")
          UserDefaults.standard.set(createEndpointResponse.endpointArn, forKey: "endpointArn")
          
          if let endpointArn = createEndpointResponse.endpointArn {
            let request = self.subscribeTopicRequest(endpointArn)
            sns.subscribe(request, completionHandler: { (response, error) in
              let service = AWSServiceManager.default().defaultServiceConfiguration
              print(service as Any)
            })
          }
        }
      }
      return task
    }.continueWith { (task) -> Any? in
        let requestAttribute = AWSSNSGetEndpointAttributesInput()!
        requestAttribute.endpointArn = UserDefaults.standard.string(forKey: "endpointArn")
        return sns.getEndpointAttributes(requestAttribute)
    }.continueWith { (task) -> Any? in
      
      if let response = task.result as? AWSSNSGetEndpointAttributesResponse {
          let requestAttribute = AWSSNSSetEndpointAttributesInput()!
          requestAttribute.endpointArn = UserDefaults.standard.string(forKey: "endpointArn")
        
          var attributes = response.attributes ?? [:]
          attributes["CustomUserData"] = user
          attributes["Enabled"] = "true"
          requestAttribute.attributes = attributes
        
          sns.setEndpointAttributes(requestAttribute).continueWith { (task) in
            
            if let error = task.error {
              print(error.localizedDescription )
            }
            
            if let response = task.result as? String {
              print(response)
            }
            return nil
          }
        }
        return nil
    }
  }

  func subscribeTopicRequest(_ endpointArn: String) -> AWSSNSSubscribeInput {
    let subscribeRequest = AWSSNSSubscribeInput()
    subscribeRequest?.endpoint = endpointArn
    subscribeRequest?.protocols = "application"
    subscribeRequest?.topicArn = Constants.SNSPlatformTopic
    
    return subscribeRequest!
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    print("userInfo: \(userInfo)")
  }
  
}
