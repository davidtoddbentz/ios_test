//
//  LoginViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 14/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit

enum Service: String {
    case Facebook, Email
}

class LoginViewController2: BaseViewController, FBSDKLoginButtonDelegate {
    
    
    var facebookBtn = FBSDKLoginButton()
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookBtn.isHidden = true
        facebookBtn.delegate = self
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowRadius = 4.0
        backgroundView.layer.shadowOpacity = 0.8
        backgroundView.clipsToBounds = false
        
        self.view.addSubview(facebookBtn)
        
        self.performSegue(withIdentifier: "userLoggedInSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userLoggedInSegue" {
            let vc = segue.destination
            print(vc)
            
        }
    }
    
    func appliactionLoggedInWith(user: User, service: Service, error: Error?) {
        if error == nil {
            self.performSegue(withIdentifier: "userLoggedInSegue", sender: self)
        }
    }
    
    @IBAction func facebookBtnTouched(_ sender: Any) {
        facebookBtn.sendActions(for: .touchUpInside)
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        var request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
        request?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                  print(error.localizedDescription)
                return
            }
            //FACEBOOK DATA IN DICTIONARY
            let userData = result as! NSDictionary
            User.sharedUser.facebookID = FBSDKAccessToken.current().userID
            User.sharedUser.name = userData.value(forKey: "name") as! String!;
            Auth.auth().signIn(with: credential) { (user, error) in
                FireBaseSynchroniser.sharedSynchroniser.add(user: User.sharedUser.name, service: .Facebook) {
                    self.performSegue(withIdentifier: "userLoggedInSegue", sender: self)
                }
            }
        })
            
        
    }
    
    
    
    //    @IBAction func signUpBtnTouched(_ sender: Any) {
    //        FIRAuth.auth()?.createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!, completion: { (user, error) in
    //            if error == nil {
    //                self.logInBtnTouched(self)
    //            }
    //        })
    //    }
    //
    //    @IBAction func logInBtnTouched(_ sender: Any) {
    //        let username = emailTxtField.text!
    //        FIRAuth.auth()?.signIn(withEmail: username, password: passwordTxtField.text!, completion: { (user, error) in
    //            if error == nil {
    //                self.appliactionLoggedInWith(user: user!, service: .Email, error: error)
    //            }
    //        })
    //    }
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! Auth.auth().signOut()
    }
}
