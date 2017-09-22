//
//  ViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/04/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginViewBottomConstraint: NSLayoutConstraint!
    
    var newPasswordRequiredVC: NewPasswordRequiredViewController?
    
    var backgroundImage: UIImage?
    
    var defaultLoginBottomHeight: CGFloat = 0.0
    
    var passwordAuthenticationCompletion =  AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>()
    var usernameText: String?
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        if let image = self.backgroundImage {
            self.backgroundImageView.image = image
        }
        
        self.defaultLoginBottomHeight = loginViewBottomConstraint.constant
        
        self.setupStyle()
        
        self.errorLabel.text = ""
        
        let logoImage = UIImage(named: "logo")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationController?.isNavigationBarHidden = false
        
        if UserPreferences.sharedManager.isUserCredentialStored() {
            UserPreferences.sharedManager.getUserCredential({ (username, password) in
                self.userTextField.text = username
            })
            self.passwordTextField.text = nil
        } else {
        }
        self.setupAccessibility()
        
    }
    
    func setupAccessibility() {
        
        self.userTextField.accessibilityIdentifier = "edit_username"
        self.passwordTextField.accessibilityIdentifier = "edit_password"
        self.signInButton.accessibilityIdentifier = "button_login"
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.errorLabel.text = ""
        

        UserPreferences.sharedManager.getUserCredential { (user, password) in
            self.userTextField.text = user
            self.passwordTextField.text = nil
            self.signIn(user, password: password)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: Setup
    
    func setupStyle() {
        
        self.loginView.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        self.loginView.isHidden = false
        
        StyleManager.defaultStyle(textField: self.userTextField)
        StyleManager.defaultStyle(textField: self.passwordTextField)
        self.signInButton.backgroundColor = UIColor.darkPastelBlue
        self.signUpButton.backgroundColor = UIColor.darkPastelBlue
        self.resetPasswordButton.backgroundColor = UIColor.pastelBlue
        
        UIView.transition(with: self.backgroundImageView,
                          duration: 1,
                          options:  UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.backgroundImageView.image = UIImage(named: "login_background2")
            }, completion: { (_) in
                self.backgroundImage = self.backgroundImageView.image
        })
    }
    
    //MARK: Keyboard
    
    func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let rect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            
            self.loginViewBottomConstraint.constant = rect.size.height
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            
            self.loginViewBottomConstraint.constant = self.defaultLoginBottomHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func signIn(_ username: String, password: String) {
        let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        userPool.delegate = self
        let detail = AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password)
        let completionSource = AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>()
        completionSource.set(result: detail)
        self.passwordAuthenticationCompletion = completionSource
        
        print(userPool.identityProviderName)
        
        self.activityIndicator.startAnimating()
        
        AmazonClientManager.sharedInstance.startSession(provider: .Cognito, username: username, password: password) { (task) -> AnyObject? in
            
            if let error = task.error {
                self.errorLabel.text = error.localizedDescription
            } else {
                UserPreferences.sharedManager.saveUserCredential(username, password: password) { error in
                    self.errorLabel.text = error?.localizedDescription ?? ""
                }
                //UserPreferences.sharedManager.synchUserS3Keychain(Constants.S3BucketName)
                self.errorLabel.text = ""
            }
            return nil
        }
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: @IBAction
    
    @IBAction func signIn(_ sender: UIButton) {
        
        guard let username = self.userTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        self.signIn(username, password: password)
        
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    

    //MARK: Storyboard
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let vc = segue.destination as? SignUpViewController {
            vc.backgroundImage = self.backgroundImage
        }
        
        if let vc = segue.destination as? ForgotPasswordViewController {
            vc.backgroundImage = self.backgroundImage
        }
        
    }

    
}

extension LoginViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
//    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {}
//    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {}
//    func startRememberDevice() -> AWSCognitoIdentityRememberDevice {}
//    func startCustomAuthentication() -> AWSCognitoIdentityCustomAuthentication {}
    
    func startNewPasswordRequired() -> AWSCognitoIdentityNewPasswordRequired {
        
        self.newPasswordRequiredVC = NewPasswordRequiredViewController.instantiateFromStoryboard(self.storyboard!)
        DispatchQueue.main.async {
            self.newPasswordRequiredVC?.usernameText = self.userTextField.text
            self.present(self.newPasswordRequiredVC!, animated: true, completion: {
                
            })
        }
        return self.newPasswordRequiredVC!
    }


}

extension LoginViewController: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.userTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        
        if textField == self.passwordTextField {
            self.passwordTextField.resignFirstResponder()
        }
        return false
    }
}
