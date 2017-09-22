//
//  AppSetupService.swift
//  BaseProject
//
//  Created by BJSS on 25/05/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import ApiAI

class AppSetupService {
    
    static let sharedInstance = AppSetupService()
    
    private init() {
        
    }
    
    func loadServices() {
        // Load Required Services
        self.loadCrashReporting()
        self.loadAppFeedback()
        self.loadAPIAI()
        self.loadFirebase()
    }
    
    private func loadAPIAI() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.apiai = ApiAI()
        let config = AIDefaultConfiguration()
        config.clientAccessToken = "4b87b818f1f442eb9131f94648a30735"
        appDelegate?.apiai?.configuration = config
    }
    
    private func loadFirebase() {
        let options = FirebaseOptions(googleAppID: EnvironmentService.getValueForKey(key: "kGoogleAppID"),
                                 bundleID: EnvironmentService.getValueForKey(key: "kBundleID"),
                                 gcmSenderID: EnvironmentService.getValueForKey(key: "kGCMSenderID"),
                                 apiKey: EnvironmentService.getValueForKey(key: "kAPIKey"),
                                 clientID: EnvironmentService.getValueForKey(key: "kClientID"),
                                 trackingID: EnvironmentService.getValueForKey(key: "kTrackingID"),
                                 androidClientID: EnvironmentService.getValueForKey(key: "kAndroidClientID"),
                                 databaseURL: EnvironmentService.getValueForKey(key:"kBackendURL"),
                                 storageBucket: "usafundspoc.appspot.com",//EnvironmentService.getValueForKey(key: "kStorageBucket"),
                                 deepLinkURLScheme: EnvironmentService.getValueForKey(key: "kDeepLinkURLScheme"))
        FirebaseApp.configure(options: options)
        Database.database().isPersistenceEnabled = true
    }
    
    private func loadCrashReporting() {
        Fabric.with([Crashlytics.self])
    }
    
    private func loadAppFeedback() {
        #if PRODUCTION
        #else
            BuddyBuildSDK.setup()
        #endif
    }
}
