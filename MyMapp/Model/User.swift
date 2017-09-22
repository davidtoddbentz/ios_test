//
//  User.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 29/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class User: NSObject {

    static let sharedUser = User()
    var facebookID: String!
    var defaults = UserDefaults.standard
    
    var name: String! {
        didSet {
            // Save name to user Defaults
            defaults.setValue(name, forKey: "UserName")
        }
    }

    
    override init() {
        super.init()
        self.facebookID = nil
        
        // Retreive from User Defaults.
        self.name = defaults.string(forKey: "UserName")
        
    }
    
    init(facebookID: String, name: String) {
        super.init()
        self.facebookID = facebookID
        self.name = name
    }
    
    
}
