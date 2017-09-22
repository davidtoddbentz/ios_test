//
//  Avatar.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 11/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit

class Avatar: NSObject {

    var name: String
    var imageURL: String
    var id: String
    
    init(name: String, imageURL: String, id: String) {
        self.name = name
        self.imageURL = imageURL
        self.id = id
        super.init()
    }
    
    override init() {
        self.name = ""
        self.imageURL = ""
        self.id = ""
        super.init()
    }
}
