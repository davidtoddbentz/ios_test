//
//  ForgotPasswordViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class ForgotPasswordViewController: UIViewController {
    
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
        self.setupStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = AmazonClientManager.sharedInstance.initializeClients(NSMutableDictionary())
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let vc = segue.destination as? ConfirmForgotPasswordViewController {
            vc.user = self.user
            vc.backgroundImage = self.backgroundImage
        }
    }
    
    
    func setupStyle() {
        
        StyleManager.defaultStyle(label: self.usernameLabel)
        StyleManager.defaultStyle(textField: self.usernameTextField)
        StyleManager.defaultStyle(button: self.resetButton)
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        
        
        guard let usernname = self.usernameTextField.text else { return }
        guard let user = self.pool?.getUser(usernname) else { return }
        self.user = user
        
        
        user.forgotPassword().continueWith(block: { (task) -> Any? in
            
            switch task.result {
            case .some( _):
                DispatchQueue.main.async(execute: {
                    self.performSegueWithIdentifier(.ConfirmForgotPassword, sender: self)
                })
                
            case .none:
                if let error = task.error {
                    AmazonClientManager.sharedInstance.showAlert(error.localizedDescription, title: "Error")
                }
            }
            return nil
        })
    }
    
}
