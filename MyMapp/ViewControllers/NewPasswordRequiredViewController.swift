//
//  NewPasswordRequiredViewController.swift
//  MyMapp
//
//  Created by Andrea Scuderi on 01/08/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class NewPasswordRequiredViewController: UIViewController {
    
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var password1: RoundTextField!
    @IBOutlet weak var password2: RoundTextField!
    @IBOutlet weak var phoneText: RoundTextField!
    @IBOutlet weak var emailText: RoundTextField!
    @IBOutlet weak var nameText: RoundTextField!

    @IBOutlet weak var newPasswordRequiredButton: UIButton!
    
    var newPasswordCompletion: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>?
    var newPasswordRequiredInput: AWSCognitoIdentityNewPasswordRequiredInput?

    @IBOutlet weak var backgroundImageView: UIImageView!
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
        self.setupStyle()
        
    }
    
    func setupStyle() {
        
        for label in labels {
            StyleManager.defaultStyle(label: label)
        }
        
        for textFields in textFields {
            StyleManager.defaultStyle(textField: textFields)
        }
        
        StyleManager.defaultStyle(button: self.newPasswordRequiredButton)
    }
    
    var usernameText: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.password1.text = nil
        self.password2.text = nil
        self.navigationController?.setNavigationBarHidden(true,   animated: false)
    }
    
    @IBAction func newPasswordRequiredPressed(_ sender: AnyObject) {
        if (self.password1.text != nil &&
            self.password2.text != nil &&
            self.password1.text == self.password2.text) {
            
            var userAttributes = self.newPasswordRequiredInput!.userAttributes
            userAttributes["given_name"] = self.nameText.text ?? ""
            userAttributes["preferred_username"]  = self.usernameText ?? ""
            userAttributes["phone_number_verified"] = nil
            userAttributes["email_verified"] = nil
            
            
            let details = AWSCognitoIdentityNewPasswordRequiredDetails(proposedPassword: self.password1.text!, userAttributes: userAttributes)
            self.newPasswordCompletion?.set(result: details)
            
             } else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter a valid password",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
        }
    }
}

extension NewPasswordRequiredViewController: AWSCognitoIdentityNewPasswordRequired {
    func getNewPasswordDetails(_ newPasswordRequiredInput: AWSCognitoIdentityNewPasswordRequiredInput, newPasswordRequiredCompletionSource:
        AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        self.newPasswordRequiredInput = newPasswordRequiredInput
        self.newPasswordCompletion = newPasswordRequiredCompletionSource
    }
    
    func didCompleteNewPasswordStepWithError(_ error: Error?) {
        if let error = error as? NSError {
            // Handle error
            print(error.localizedDescription)
        } else {
            // Handle success, in my case simply dismiss the view controller
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
