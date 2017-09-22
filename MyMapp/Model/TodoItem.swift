//
//  TodoItem.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 23/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class TodoItem: NSObject {
    var completed: Bool
    var title: String
    
    
    init(title: String, completed: Bool) {
        self.completed = completed
        self.title = title
        super.init()
    }
}
