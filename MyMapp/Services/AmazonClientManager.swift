/*
 * Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import Foundation
import AWSCore
import AWSCognito
import AWSCognitoIdentityProvider
import AWSSNS
import KeychainAccess

#if ACM_FACEBOOK
    import FBSDKCoreKit
    import FBSDKLoginKit
    import FBSDKShareKit
#endif

typealias AWSContinuationBlock = (AWSTask<AnyObject>)->Any?


public class AmazonClientManager: NSObject, AuthenticationManagerDelegate {
    
    static let sharedInstance = AmazonClientManager()
    
    var keyChain: Keychain
    var completionHandler: AWSContinuationBlock?
    var credentialsProvider: AWSCognitoCredentialsProvider?
    //var devAuthClient: DeveloperAuthenticationClient?
    
    fileprivate var unauthenticatedAccess = false
    
    var identityProviderManager: AmazonIdentityProviderManager?
    var authenticationProviders: [AuthenticationProviding]
    var currentProvider: AuthenticationProviding?
    
    var enableAWSSNS = true
    
    override private init() {
        keyChain = Keychain(service: "\(Bundle.main.bundleIdentifier!).\(AmazonClientManager.self)")
        self.authenticationProviders = []
        super.init()
        self.authenticationProviders = defaultAutheticationProviders()
        self.initializeAWS()
    }
    
    func authenticationProvider(with provider: AuthenticationProviderName) -> AuthenticationProviding? {
        return self.authenticationProviders.filter { (authProvider) -> Bool in
            return authProvider.provider == provider
        }.first
    }
    
    func defaultAutheticationProviders() -> [AuthenticationProviding] {
        
        let cognitoAuthenticationProvider = CognitoUserPoolAuthenticationProvider(keychain: keyChain, auth: self)
        
        var providers: [AuthenticationProviding] = [
            cognitoAuthenticationProvider]
        
        #if ACM_UNAUTHENTICATED
            let undefinedAuthenticationProvider = UndefinedAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(undefinedAuthenticationProvider)
        #endif
        
        #if ACM_FACEBOOK
            let fbAuthenticationProvider = FacebookAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(fbAuthenticationProvider)
        #endif
        
        #if ACM_GOOGLE
            let googleAuthenticationProvider = GoogleAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(googleAuthenticationProvider)
        #endif
        
        #if ACM_AI
            let aiAuthenticationProvider = AIAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(aiAuthenticationProvider)
        #endif
        
        #if ACM_TWITTER
            let twitterAuthenticationProvider = TwitterAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(twitterAuthenticationProvider)
        #endif
        
        #if ACM_DIGITS
            let digitsAuthenticationProvider = DigitsAuthenticationProvider(keychain: keyChain, auth: self)
            providers.append(digitsAuthenticationProvider)
        #endif
        
        #if ACM_BYO
            let byoAuthenticationProvider = BYOAuthenticationProvider(keychain: keyChain, auth: self)
            self.devAuthClient = byoAuthenticationProvider.devAuthClient
            providers.append(byoAuthenticationProvider)
        #endif
        
        return providers
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        
        #if ACM_FACEBOOK
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        #endif
        return false
    }
    
    // MARK: General Login
  
    
    func start(_ completionHandler: @escaping AWSContinuationBlock) {
        if self.isConfigured() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            self.resumeSession({
                (task) -> Any? in
                if self.enableAWSSNS {
                    AmazonSNSManager.sharedInstance.registerToken(user: task.result as? String)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return completionHandler(task)
            })
            
        } else {
            AmazonClientManager.sharedInstance.showAlert("Please check Constants.swift and set appropriate values", title: "Missing AWS Configuration")
        }
    }
    
    func isConfigured() -> Bool {
        return !(Constants.CognitoIdentityPoolID == "YourCognitoIdentityPoolId" || Constants.CognitoRegionType == AWSRegionType.Unknown)
    }
    
    func resumeSession(_ completionHandler: @escaping AWSContinuationBlock) {
        
        self.completionHandler = completionHandler
        for authProvider in self.authenticationProviders {
            
            if authProvider.isInSession {
                authProvider.reloadSession()
                self.currentProvider = authProvider
            }
        }
        if self.credentialsProvider == nil {
            self.completeLogin(NSMutableDictionary())
        }
    }
    
    //Sends the appropriate URL based on login provider
    func application(_ application: UIApplication,
                     openURL url: URL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        #if ACM_GOOGLE
            if GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation) {
                return true
            }
        #endif
        
        #if ACM_FACEBOOK
            if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
                return true
            }
        #endif
        
        #if ACM_AI
            if AIMobileLib.handleOpen(url, sourceApplication: sourceApplication) {
                return true
            }
            
        #endif
        
        return false
    }
    
    func completeLogin(_ logins: NSMutableDictionary) {
        var task: AWSTask<NSString>?
        
        if self.credentialsProvider == nil {
            task = self.initializeClients(logins)
            self.identityProviderManager?.mergeLogins(logins)
            
        } else {
            
            self.identityProviderManager?.mergeLogins(logins)
            credentialsProvider?.invalidateCachedTemporaryCredentials()
            task = credentialsProvider?.getIdentityId()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task?.continueWith(block: {
            (task: AWSTask!) -> Any! in
            if task.error != nil {
                let userDefaults = UserDefaults.standard
                let currentDeviceToken: Data? = userDefaults.object(forKey: Constants.DeviceTokenKey) as? Data
                var currentDeviceTokenString: String
                
                if currentDeviceToken != nil {
                    currentDeviceTokenString = currentDeviceToken!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
                } else {
                    currentDeviceTokenString = ""
                }
                
                if currentDeviceToken != nil && currentDeviceTokenString != userDefaults.string(forKey: Constants.CognitoDeviceTokenKey) {
                    
                    AWSCognito.default().registerDevice(currentDeviceToken!).continueWith(block: { (task: AWSTask!) -> AnyObject! in
                        if task.error == nil {
                            userDefaults.set(currentDeviceTokenString, forKey: Constants.CognitoDeviceTokenKey)
                            userDefaults.synchronize()
                        }
                        return nil
                    })
                }
            } else {
                //print("identityId: \(task.result)")
            }
            return task
        }).continueWith(block: { (task) -> Any? in
            
            if let completionHandler = self.completionHandler {
                return completionHandler(task)
            }
            return nil
        }).continueWith(block: { (task) -> Any? in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.postNotification(.AmazonClientManagerDidLogin, userInfo: nil)
            return nil
        })
    }
    
    func initializeAWS() {
        print("Initializing Clients...")
        
        AWSLogger.default().logLevel = AWSLogLevel.verbose
        
        //Cognito User Pool config
        let serviceConfiguration = AWSServiceConfiguration(region: Constants.CognitoRegionType, credentialsProvider: nil)
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: Constants.CognitoIdentityUserPoolAppClientId,
                                                                            clientSecret: Constants.CognitoIdentityUserPoolAppClientSecret,
                                                                            poolId: Constants.CognitoIdentityUserPoolId)
        
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: userPoolConfiguration,
                                            forKey: "UserPool")
        
        self.identityProviderManager = AmazonIdentityProviderManager.sharedInstance
        
        var credentialsProvider: AWSCognitoCredentialsProvider!
        
        #if ACM_BYO
            if self.devAuthClient != nil {
                
                print("With Developer Authentication...")
                let identityProvider = DeveloperAuthenticatedIdentityProvider(
                    regionType: Constants.CognitoRegionType,
                    identityPoolId: Constants.CognitoIdentityPoolID,
                    providerName: Constants.DeveloperAuthProviderName,
                    authClient: self.devAuthClient,
                    identityProviderManager: self.identityProviderManager)
                
                
                credentialsProvider = AWSCognitoCredentialsProvider(
                    regionType: Constants.CognitoRegionType,
                    unauthRoleArn: nil,
                    authRoleArn: nil,
                    identityProvider: identityProvider!)
            } else {
                credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constants.CognitoRegionType,
                                                                    identityPoolId: Constants.CognitoIdentityPoolID,
                                                                    identityProviderManager: self.identityProviderManager)
            }

        #else
            credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constants.CognitoRegionType,
                                                                identityPoolId: Constants.CognitoIdentityPoolID,
                                                                identityProviderManager: self.identityProviderManager)
        #endif
        let defaultServiceConfiguration = AWSServiceConfiguration(region: Constants.CognitoRegionType,
                                                                  credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
    }
    
    func initializeClients(_ logins: NSMutableDictionary) -> AWSTask<NSString>? {
        print("Initializing Clients...")
        
        AWSLogger.default().logLevel = AWSLogLevel.verbose
        self.credentialsProvider = AWSServiceManager.default().defaultServiceConfiguration.credentialsProvider as? AWSCognitoCredentialsProvider
        return self.credentialsProvider?.getIdentityId()
    }
    
    func loginFromView(from viewController: UIViewController, withCompletionHandler completionHandler: @escaping AWSContinuationBlock) {
        self.completionHandler = completionHandler
        self.displayLoginSheet(from: viewController)
    }
    
    func logOut(_ completionHandler: @escaping AWSContinuationBlock) {
       
        for authProvider in self.authenticationProviders {
            
            if authProvider.isAuthenticated {
                authProvider.endSession()
        
            }
        }
        self.currentProvider = nil
        
        // Wipe credentials
        self.identityProviderManager?.reset()
        
        AWSCognito.default().wipe()
        self.credentialsProvider?.clearKeychain()
        
        self.credentialsProvider?.clearCredentials()
        
        
        AWSTask(result: nil).continueWith(block: completionHandler).continueWith(block: { (task) -> Any? in
            self.postNotification(.AmazonClientManagerDidLogout, userInfo: nil)
            return nil
        })
    }
    
    func isLoggedIn() -> Bool {
        
        for provider in self.authenticationProviders {
            
            if provider.isAuthenticated {
                return true
            }
        }
        return false
    }

    func isLoggedUnauthenticated() -> Bool {
        return self.authenticationProvider(with: .Undefined)?.isAuthenticated ?? false
    }

    
    func startSession(provider: AuthenticationProviderName, username: String, password: String, with completionHandler: @escaping (AWSTask<AnyObject>) -> Any?) {
    
        self.completionHandler = completionHandler
        if let currentProvider = self.authenticationProvider(with: provider) as? CredentialAuthenticationProviding {
            self.currentProvider = currentProvider
            currentProvider.startSession(username: username, password: password)
        } else {
            AmazonClientManager.sharedInstance.showAlert("Unable find the provider \(provider)", title: "Error")
        }
    }

    // MARK: UI Helpers
    func showLogin(authProvider: CredentialAuthenticationProviding, from viewController: UIViewController?) {
        var username: UITextField!
        var password: UITextField!
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "AWS Client"
        let loginAlert = UIAlertController(title: appName, message: "Enter Credentials", preferredStyle: UIAlertControllerStyle.alert)
        
        loginAlert.addTextField { (textField) -> Void in
            textField.placeholder = "email"
            username = textField
        }
        loginAlert.addTextField { (textField) -> Void in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
            password = textField
        }
        
        let loginAction = UIAlertAction(title: "Sign In", style: .default) { (action) -> Void in
            
            if let validUsername = username.text,
                let validPassword = password.text {
                
                authProvider.startSession(username: validUsername, password: validPassword)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        loginAlert.addAction(loginAction)
        loginAlert.addAction(cancelAction)
      
        viewController?.present(loginAlert, animated: true, completion: nil)
    }
    
    func displayLoginSheet(from viewController: UIViewController?) {
        let loginProviders = UIAlertController(title: nil, message: "Login With:", preferredStyle: .actionSheet)
        
        for authProvider in self.authenticationProviders {
       
            let action = UIAlertAction(title: authProvider.provider.rawValue, style: .default) {
                (alert: UIAlertAction) -> Void in
                
                if let authCredentialProvider = authProvider as? CredentialAuthenticationProviding {
                    self.showLogin(authProvider: authCredentialProvider, from: viewController)
                } else {
                    authProvider.startSession()
                }
            }
            loginProviders.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alert: UIAlertAction!) -> Void in
            AWSTask(result: nil).continueWith(block: self.completionHandler!)
        }
        
        loginProviders.addAction(cancelAction)
      
        let center = viewController?.view.bounds.size.width ?? 20
        loginProviders.popoverPresentationController?.sourceRect = CGRect(x:  center/2.0 - 10, y: 0, width: 20, height: 20)
        loginProviders.popoverPresentationController?.sourceView = viewController?.view
      
        viewController?.present(loginProviders, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String, title: String) {
        DispatchQueue.main.async {
            
            let errorAlert = UIAlertController(title: title, message: "\(message)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in }
            errorAlert.addAction(okAction)
            
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//                let visibleViewController = appDelegate.window?.visibleViewController() {
//                visibleViewController.present(errorAlert, animated: true, completion: nil)
//            }
        }
    }
    
    func sessionDidFail(with error: Error) {
        
        if let completionHandler = self.completionHandler {
            let errorTask = AWSTask<AnyObject>(error: error)
            _ = completionHandler(errorTask)
        } else {
            self.showAlert(error.localizedDescription, title: "Error")
        }
    }
    
    func sessionWillStart(with provider: AuthenticationProviding) {
        self.currentProvider = provider
    }
}
