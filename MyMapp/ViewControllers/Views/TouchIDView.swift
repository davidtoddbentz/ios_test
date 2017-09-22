//
//  TouchIDView.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class TouchIDView: UIView {

    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    func commonInit() {
        
        self.touchIDSwitch.isOn = UserPreferences.sharedManager.isTouchIdEnabled
    }

    
    @IBAction func touchIDChanged(_ sender: AnyObject) {
        
        UserPreferences.sharedManager.isTouchIdEnabled = self.touchIDSwitch.isOn
        if self.touchIDSwitch.isOn == false {
            UserPreferences.sharedManager.removeUserCredential()
        }
    }
}
