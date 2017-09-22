//
//  AppDelegate.swift
//  BaseProject
//
//  Created by BJSS on 25/05/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import ApiAI
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var apiai: ApiAI?
    var interstitialView: InterstitialView?
    
    override init() {
        super.init()
        
        // Load and Configure Application
        let _ = AppSetupService.sharedInstance
        setupAppearance()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let vc = self.window?.rootViewController as? BaseTabBarController {
            if let host = url.host {
                switch host {
                case "badges":
                    vc.didSelectMenuItem(atIndex: ViewController.badges.rawValue)
                case "roadmap":
                    vc.didSelectMenuItem(atIndex: ViewController.roadmap.rawValue)
                case "careers":
                    vc.didSelectMenuItem(atIndex: ViewController.careers.rawValue)
                case "chat":
                    vc.didSelectMenuItem(atIndex: ViewController.chat.rawValue)
                case "videos":
                    vc.didSelectMenuItem(atIndex: ViewController.videos.rawValue)
                case "profile":
                    vc.didSelectMenuItem(atIndex: ViewController.profile.rawValue)
                case "colleges":
                    vc.didSelectMenuItem(atIndex: ViewController.colleges.rawValue)
                case "avatarSelect":
                    vc.didSelectMenuItem(atIndex: ViewController.avatarSelect.rawValue)
                default:
                    print("this feature hos not yet been implemented")
                    
                }
            }
            
            
        }
        
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Load Application Services
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        AppSetupService.sharedInstance.loadServices()
        
        // Setup Notificatios
        loadPusher(application: application)
        
        IQKeyboardManager.sharedManager().enable = true
        checkIfLoginRequired()
        return true
    }
    
    func setupAppearance() {
        UIApplication.shared.delegate?.window??.backgroundColor = UIColor.white
    }
    
    func checkIfLoginRequired() {
//        if  FBSDKAccessToken.current() == nil {
//            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
//        } else {
//            User.sharedUser.facebookID = FBSDKAccessToken.current().userID
//            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//            Auth.auth().signIn(with: credential)
//        }
    }
    
    // Pusher Notifications
    
    func loadPusher(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            //center.delegate = self
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
            }
            application.registerForRemoteNotifications()
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        FireBaseSynchroniser.sharedSynchroniser.setDeviceToken()
        print("Registered for Notifications: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    func application(_ apzresztaplication: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData) // indicates that new data was successfully fetched
    }
    
    
    //    @available(iOS 10.0, *)
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //        print("Did Receive Notification")
    //        completionHandler()
    //    }
    //
    //    @available(iOS 10.0, *)
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        print("Will Present Notification")
    //        completionHandler(.alert)
    //    }
    
    
    //    // PUSH WOOSH NOTIFICATIONS
    //    private func loadPushNotifications(launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) {
    //        if let pushManager = PushNotificationManager.push() {
    //            pushManager.delegate = self
    //            pushManager.handlePushReceived(launchOptions)
    //            pushManager.sendAppOpen()
    //            pushManager.registerForPushNotifications()
    //        }
    //    }
    //
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        PushNotificationManager.push().handlePushRegistration(deviceToken)
    //    }
    //
    //    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //        PushNotificationManager.push().handlePushRegistrationFailure(error)
    //    }
    //
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //        PushNotificationManager.push().handlePushReceived(userInfo)
    //    }
    //
    //    func onPushAccepted(_ pushManager: PushNotificationManager!, withNotification pushNotification: [AnyHashable : Any]!, onStart: Bool) {
    //        print("Push notification accepted: \(pushNotification)");
    //    }
    
    
    
}
