//
//  FirebaseService.swift
//  BaseProject
//
//  Created by BJSS on 25/05/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
//import Firebase


class FirebaseService {

  static let sharedInstance = FirebaseService()

  private init() {

    // Initialize Firebase
    let options = FirebaseOptions(googleAppID: EnvironmentService.getValueForKey(key: "kGoogleAppID"),
                             bundleID: EnvironmentService.getValueForKey(key: "kBundleID"),
                             gcmSenderID: EnvironmentService.getValueForKey(key: "kGCMSenderID"),
                             apiKey: EnvironmentService.getValueForKey(key: "kAPIKey"),
                             clientID: EnvironmentService.getValueForKey(key: "kClientID"),
                             trackingID: EnvironmentService.getValueForKey(key: "kTrackingID"),
                             androidClientID: EnvironmentService.getValueForKey(key: "kAndroidClientID"),
                             databaseURL: EnvironmentService.getValueForKey(key: "kBackendURL"),
                             storageBucket: EnvironmentService.getValueForKey(key: "kStorageBucket"),
                             deepLinkURLScheme: EnvironmentService.getValueForKey(key: "kDeepLinkURLScheme"))

    FirebaseApp.configure(options: options)
    
  }
}
