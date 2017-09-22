//
//  SplashScreenViewController.swift
//  BJSSMeet
//
//  Created by Andrea Scuderi on 05/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var viewModel: SocialLoginViewModel?
    let duration: TimeInterval = 0.5
    
    static func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmazonClientManager.sharedInstance.addObserver(self)
        
        AmazonClientManager.sharedInstance.enableAWSSNS = true
        
        AmazonClientManager.sharedInstance.start { (task) -> Any? in
            DispatchQueue.main.async {
                self.refreshUI()
            }
        }
    }
    
    deinit {
        AmazonClientManager.sharedInstance.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
        AmazonClientManager.sharedInstance.logOut {
            (task) -> Any? in
    //        UserPreferences.sharedManager.resetUserS3Keychain(Constants.S3BucketName)
            return nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func refreshUI() {
        
        let expandTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseOut, animations: {
            self.logoImageView.transform = expandTransform
            
        }) { (_) in
            
            self.preLoad("SocialLoginModel") {
                if AmazonClientManager.sharedInstance.isLoggedIn() {
                    //self.amazonClientManagerDidLogin()
                } else {
                    self.amazonClientManagerDidLogout()
                }
            }
        }
    }
    
    
    func preLoad(_ file: String?, completion:@escaping ()->()) {
        
        if let file = file {
            self.viewModel = SocialLoginViewModel(file: file)
            completion()
        } else {
            let viewModelBuilder = SocialLoginViewModelService()
            viewModelBuilder.load { (result) in
                switch result {
                case .success(let viewModel):
                    self.viewModel = viewModel
                case .error(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? SocialLoginViewController {
            vc.viewModel = self.viewModel
        }
    }
    
}

extension SplashScreenViewController: AmazonClientManagerObserver {
    
    func amazonClientManagerDidLogout() {
        
        guard !AmazonClientManager.sharedInstance.isLoggedIn() else { return }
        
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: {
                self.performSegueWithIdentifier(SegueIdentifier.SocialLogin, sender: nil)
            })
        } else {
            self.performSegueWithIdentifier(SegueIdentifier.SocialLogin, sender: nil)
        }
    }
    
    func amazonClientManagerDidFailLogin(_ notification: Notification) {
        
        if let error = (notification as NSNotification).userInfo?[NSString(string:"error")] as? NSError, error.code == 11 { //Incorrect username or password
            UserPreferences.sharedManager.removeUserCredential()
        }
    }
    
    func amazonClientManagerDidLogin() {
        
        guard AmazonClientManager.sharedInstance.isLoggedIn() else { return }
        
        var segueIdentifier = SegueIdentifier.AutoLogin
        if AmazonClientManager.sharedInstance.isLoggedUnauthenticated() {
            //segueIdentifier = SegueIdentifier.Unauthenticated
            return
        }
        
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: {
                self.performSegueWithIdentifier(segueIdentifier, sender: nil)
            })
        } else {
            SplashScreenViewController.runAfterDelay(self.duration) {
                self.performSegueWithIdentifier(segueIdentifier, sender: nil)
            }
        }
    }
}
