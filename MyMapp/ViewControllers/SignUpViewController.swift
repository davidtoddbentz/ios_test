//
//  SignUpViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 24/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

class SignUpViewController: UIViewController {
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signUPButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var familynameText: UITextField!
    @IBOutlet weak var birthdateText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var pictureText: UITextField!
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
        
        self.setupStyle()
        //    self.usernameText.text = "test.user@bjss.com"
        //    self.passwordText.text = "BJss!2345"
        //    self.phoneText.text = "+44000000000"
        //    self.emailText.text = "test.user@bjss.com"
        //    self.familynameText.text = "User"
        //    self.birthdateText.text = "01/01/1970"
        //    self.nameText.text = "Test"
        //    self.pictureText.text = "http://api.adorable.io/avatars/110/\(self.usernameText.text!).png"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func setupStyle() {
    
        for label in labels {
            StyleManager.defaultStyle(label: label)
        }
        
        for textFields in textFields {
            StyleManager.defaultStyle(textField: textFields)
        }
        
        StyleManager.defaultStyle(button: self.signUPButton)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cvc = segue.destination as? ConfirmSignUpViewController,
            let username = self.usernameText.text {
            cvc.sentTo = self.sentTo
            cvc.user = self.pool?.getUser(username)
            cvc.backgroundImage = self.backgroundImage
        }
    }
    
    func buildAttribute(_ textField: UITextField, name: String) -> AWSCognitoIdentityUserAttributeType? {
        
        if let textString = textField.text {
            let attribute = AWSCognitoIdentityUserAttributeType()
            attribute?.name = name
            attribute?.value = textString
            return attribute
        }
        return nil
    }
    
    func buildAttributes() -> [AWSCognitoIdentityUserAttributeType] {
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let phone = self.buildAttribute(self.phoneText, name: "phone_number") {
            attributes.append(phone)
        }
        
        if let email = self.buildAttribute(self.emailText, name: "email") {
            attributes.append(email)
        }
        
        if let name = self.buildAttribute(self.nameText, name: "name") {
            attributes.append(name)
        }
        
        if let familyname = self.buildAttribute(self.familynameText, name: "family_name") {
            attributes.append(familyname)
        }
        
        if let birthdate = self.buildAttribute(self.birthdateText, name: "birthdate") {
            attributes.append(birthdate)
        }
        
        if let picture = self.buildAttribute(self.pictureText, name: "picture") {
            attributes.append(picture)
        }
        
        if let locale = self.buildAttribute(self.pictureText, name: "locale") {
            attributes.append(locale)
        }
        return attributes
    }
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        _ = AmazonClientManager.sharedInstance.initializeClients(NSMutableDictionary())
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        
        guard let username = self.usernameText.text else { return }
        guard let password = self.passwordText.text else { return }
        
        let attributes = buildAttributes()
        
        self.pool?.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith(block: { (task) -> AnyObject? in
            
            switch task.result {
            case .some(let result):
                print("Successful signUp user: %@", result.user.username)
                DispatchQueue.main.async(execute: {
                    
                    if result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed {
                        self.sentTo = task.result!.codeDeliveryDetails!.destination
                        self.performSegueWithIdentifier(.ConfirmSignUp, sender: sender)
                    } else {
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                })
                
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
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == self.phoneText {
//            do {
//                let regex = try NSRegularExpression(pattern: "^\\+(|\\d)*$", options: NSRegularExpression.Options.caseInsensitive)
//                var proposedPhone = self.phoneText.text?.replacingCharacters( in: string.range(from:range)!, with: string)
//                if proposedPhone?.characters.count != 0 {
//                    return regex.numberOfMatches(in: proposedPhone ?? "", options: [.anchored], range: NSRange(location: 0, length: (proposedPhone?.characters.count)!)) == 1
//                }
//            } catch {
//                
//            }
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.usernameText {
            self.pictureText.text = "http://api.adorable.io/avatars/110/\(self.usernameText.text ?? "00").png"
        }
    }
}
