//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 21/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var headerV: UIView!
    
    var interstitialPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if let header = self.headerV {
            header.layer.cornerRadius = 30.0
            header.layer.shadowOpacity = 0.8
            header.layer.shadowRadius = 4.0
            header.layer.shadowColor = UIColor.gray.cgColor
        }
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.interstitialView == nil {
                let interstitialView = InterstitialView(frame: self.view.frame)
                appDelegate.interstitialView = interstitialView
            }
            
            if !interstitialPresented {
                self.view.addSubview(appDelegate.interstitialView!)
                interstitialPresented = true
                self.tabBarController?.tabBar.isHidden = true
            } else {
                appDelegate.interstitialView?.removeFromSuperview()
                interstitialPresented = false
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    }
    
    
}
