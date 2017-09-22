//
//  AuthenticationProviding.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import KeychainAccess

enum AuthenticationProviderName: String {
    case Facebook
    case Google
    case Amazon
    case Twitter
    case Digits
    case BYOI
    case Cognito
    case Undefined
}

func == (lhs: AuthenticationProviderName, rhs: AuthenticationProviderName) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

protocol AuthenticationManagerDelegate {
    func completeLogin(_ logins: NSMutableDictionary)
    func sessionDidFail(with error: Error)
    func sessionWillStart(with provider: AuthenticationProviding)
}

protocol AuthenticationProviding {
    var provider: AuthenticationProviderName { get }
    var keychain: Keychain { get }
    var isAuthenticated: Bool { get }
    var isInSession: Bool { get }
    
    var loginViewController: UIViewController? { get set }
    
    var delegate: AuthenticationManagerDelegate { get }
    func startSession()
    func endSession()
    func reloadSession()
    
    init(keychain: Keychain, auth delegate: AuthenticationManagerDelegate)
}

protocol CredentialAuthenticationProviding: AuthenticationProviding {
    func startSession(username: String, password: String)
    var userPreference: UserPreferences? { get set }
}
