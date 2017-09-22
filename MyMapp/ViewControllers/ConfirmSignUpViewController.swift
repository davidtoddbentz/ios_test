//
//  ConfirmSignUpViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 27/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class ConfirmSignUpViewController: UIViewController {
    
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var user: AWSCognitoIdentityUser?
    var sentTo: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.usernameText.text = self.user?.username
        self.sentToLabel.text = "Code sent to: \(self.sentTo)"
    }
    
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStyle()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
    }
    
    func setupStyle() {
        
        for label in self.labels {
            StyleManager.defaultStyle(label: label)
        }
        
        for textField in self.textFields {
            StyleManager.defaultStyle(textField: textField)
        }
        
        StyleManager.defaultStyle(button: self.confirmButton)
    }
    
    
    @IBAction func confirm(_ sender: AnyObject) {
        
        self.user?.confirmSignUp(self.codeText.text ?? "").continueWith(block: { (task) -> AnyObject? in
            
            switch task.result {
            case .some( _):
                DispatchQueue.main.async(execute: {
                    //return to signin screen
                    self.performSegue(withIdentifier: "codeConfirmedSegue", sender: self)
                })
            case .none:
                if let error = task.error {
                    AmazonClientManager.sharedInstance.showAlert(error.localizedDescription, title: "Error")
                }
            }
            return nil
        })
    }
    
    @IBAction func resend(_ sender: AnyObject) {
        
        self.user?.resendConfirmationCode().continueWith(block: { (task) -> AnyObject? in
            switch task.result {
            case .some(let result):
                AmazonClientManager.sharedInstance.showAlert("Code resent to: \(result.codeDeliveryDetails?.destination)", title: "Reset Password")
            case .none:
                if let error = task.error {
                    AmazonClientManager.sharedInstance.showAlert(error.localizedDescription, title: "Error")
                } else {
                    AmazonClientManager.sharedInstance.showAlert("Unknown", title: "Error")
                }
            }
            return nil
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
