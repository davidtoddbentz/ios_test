//
//  ChooseAvatarViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 11/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import Contacts
import ImagePicker

protocol ChooseAvatarViewControllerDelegate {
    func didSelectNewAvatar(avatar: Avatar)
}

class ChooseAvatarViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewAvatars: UITableView!
    var avatars: [Avatar] = []
    var avatarID: String?
    var delegate: ChooseAvatarViewControllerDelegate?
    var lastSelectedCell: AvatarSelectionCell?
    var isCreatingAvatar = false
    var avatarCreationView: AvatarCreationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAvatars.delegate = self
        tableViewAvatars.dataSource = self
        tableViewAvatars.tableFooterView = UIView()
        self.reloadData()
    }
    
    func reloadData() {
        FireBaseSynchroniser.sharedSynchroniser.getAvatars { (avatars) in
            self.avatars = avatars
            self.tableViewAvatars.reloadData()
            FireBaseSynchroniser.sharedSynchroniser.getAvatar(completion: { (avatarID) in
                self.avatarID = avatarID
                self.tableViewAvatars.reloadData()
            })
        }
    }
}

extension ChooseAvatarViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avatars.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarSelectionCell", for: indexPath)
        if let cell = cell as? AvatarSelectionCell {
            if indexPath.row > 0 {
                let avatar = avatars[indexPath.row - 1]
                cell.setup(avatar: avatar)
                cell.setToggle(on: (avatarID == avatar.id))
            } else {
                cell.setupUploadCell()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row > 0 {
            let avatar = avatars[indexPath.row - 1]
            lastSelectedCell = tableView.cellForRow(at: indexPath) as! AvatarSelectionCell?
            FireBaseSynchroniser.sharedSynchroniser.setAvatar(id: avatar.id) {
                if let img = self.lastSelectedCell?.avatar.image {
                    self.saveAvatarImageToUserDefaults(img)
                }
                self.addContact(avatar)
                
                if UserDefaults.standard.value(forKey: "firstLaunch") == nil {
                    UserDefaults.standard.set(true, forKey: "firstLaunch")
                    self.tableViewAvatars.reloadData()
                    self.tabBarController?.selectedIndex = 1
                } else {
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
            self.delegate?.didSelectNewAvatar(avatar: avatar)
        } else {
            
            avatarCreationView = AvatarCreationView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            if let avatarVC = avatarCreationView {
                avatarVC.delegate = self
                avatarVC.center = self.view.center
                self.view.addSubview(avatarVC)
            }
        }
        
    }
    
    func saveAvatarImageToUserDefaults(_ image: UIImage) {
        let defaults = UserDefaults.standard
        let imageData = UIImagePNGRepresentation(image)
        defaults.set(imageData, forKey: "avatarImage")
    }
    
    func addContact(_ avatar: Avatar) {
        
        let contact = CNMutableContact()
        if let img = lastSelectedCell?.avatar.image {
            contact.imageData = UIImagePNGRepresentation(img)
        }
        
        let nameFormatter = PersonNameComponentsFormatter()
        if #available(iOS 10.0, *) {
            let components = nameFormatter.personNameComponents(from: avatar.name)
            if let components = components {
                contact.givenName = components.givenName ?? ""
                contact.familyName = components.familyName ?? ""
            }
        } else {
            var wordArray = avatar.name.components(separatedBy: " ")
            contact.givenName = wordArray[0]
            contact.familyName = wordArray[wordArray.count - 1]
        }
        
        let workEmail = CNLabeledValue(label: CNLabelWork, value: "bjss.mobile@icloud.com" as NSString)
        contact.emailAddresses = [workEmail]
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        do {
            try store.execute(saveRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ChooseAvatarViewController: AvatarCreationDelegate {
    func didFinishCreatingAvatar() {
        self.reloadData()
        UIView.animate(withDuration: 0.25, animations: { 
            self.avatarCreationView?.alpha = 0.0
        }) { (completed) in
            self.avatarCreationView = nil
        }
    }
}
