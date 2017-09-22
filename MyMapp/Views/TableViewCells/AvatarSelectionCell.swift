//
//  AvatarSelectionCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 11/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class AvatarSelectionCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var onOffToggle: UIImageView!
    
    func setup(avatar: Avatar) {
        if let url = URL(string: avatar.imageURL) {
            self.avatar.sd_setImage(with: url)
        }
        self.avatar.layer.cornerRadius = self.avatar.bounds.height / 2.0
        self.name.text = avatar.name
    }
    
    func setupUploadCell() {
        self.avatar.image = #imageLiteral(resourceName: "uploadYourOwn")
        self.name.text = "Upload your own"
        self.onOffToggle.image = nil
    }
    
    func setToggle(on: Bool) {
        self.onOffToggle.image = on ? #imageLiteral(resourceName: "avatarSelected") : #imageLiteral(resourceName: "avatarDeselected")
    }
}
