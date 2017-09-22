//
//  PreferencesViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 10/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit

class PreferencesViewController: BaseViewController, ChooseAvatarViewControllerDelegate {
    
    
    @IBOutlet weak var parentEmail: UITextField!
    @IBOutlet weak var counselorEmail: UITextField!
    @IBOutlet weak var assistantAvatar: UIImageView!
    @IBOutlet weak var assistantName: UILabel!
    @IBOutlet weak var assistantStackView: UIStackView!
    @IBOutlet weak var signOutButton: UIButton!
    var avatars: [Avatar] = []
    var avatar = Avatar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        assistantStackView.addGestureRecognizer(tapGesture)
        didSelectNewAvatar(avatar: avatar)
        
        assistantStackView.accessibilityIdentifier = "AssistantStackView"
        assistantStackView.isAccessibilityElement = true
        
        FireBaseSynchroniser.sharedSynchroniser.getAvatars { (avatars) in
            self.avatars = avatars
            self.getLatestAvatar()
        }
        FireBaseSynchroniser.sharedSynchroniser.getParentEmail { (parentEmail) in
            self.parentEmail.text = parentEmail
        }
        FireBaseSynchroniser.sharedSynchroniser.getCounselorEmail { (counselorEmail) in
            self.counselorEmail.text = counselorEmail
        }
        
        self.signOutButton.accessibilityIdentifier = "SignOutButton"
        self.signOutButton.isAccessibilityElement = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        assistantAvatar.layer.cornerRadius = assistantAvatar.bounds.height / 2.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseAvatarSegue" {
            if let destVC = segue.destination as? ChooseAvatarViewController {
                destVC.delegate = self
            }
            
        }
    }
    
    func getLatestAvatar() {
        FireBaseSynchroniser.sharedSynchroniser.getAvatar { (id) in
            for avatar in self.avatars {
                if avatar.id == id {
                    self.avatar = avatar
                    self.didSelectNewAvatar(avatar: avatar)
                }
            }
        }
    }
    
    @IBAction func didTapAvatar(_ sender: Any) {
        self.performSegue(withIdentifier: "chooseAvatarSegue", sender: self)
    }
    
    
    
    func didSelectNewAvatar(avatar: Avatar) {
        if let url = URL(string: avatar.imageURL) {
            assistantAvatar.sd_setImage(with: url)
        }
        if avatar.name.characters.count > 0 {
            assistantName.text = avatar.name
        }
    }
    
    @IBAction func didTapSignOut(_ sender: Any) {
        
//        FBSDKLoginManager().logOut()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = vc
//        appDelegate.window?.makeKeyAndVisible()
        
        
        
    }
    
}
