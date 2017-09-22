//
//  ConfirmForgotPasswordViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class ConfirmForgotPasswordViewController: UIViewController {
    
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    @IBOutlet weak var proposedPasswordTextField: UITextField!
    
    @IBOutlet weak var resendButton: UIButton!
    
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupStyle()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupStyle() {
        
        for label in self.labels {
            StyleManager.defaultStyle(label: label)
        }
        
        for textFields in self.textFields {
            StyleManager.defaultStyle(textField: textFields)
        }
        
        StyleManager.defaultStyle(button: self.resendButton)
    }
    
    
    @IBAction func updatePassword(_ sender: AnyObject) {
        
        guard let confirmationCode = self.confirmationCodeTextField.text else { return }
        guard let proposedPassword = self.proposedPasswordTextField.text else { return }
        guard let user = self.user else { return }
        
        user.confirmForgotPassword(confirmationCode, password: proposedPassword).continueWith(block: { (task) -> Any? in
            
            switch task.result {
            case .some( _):
                DispatchQueue.main.async(execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
                
            case .none:
                if let error = task.error as? NSError {
                    AmazonClientManager.sharedInstance.showAlert(error.localizedDescription, title: "Error")
                }
            }
            return nil
        })
    }
}
