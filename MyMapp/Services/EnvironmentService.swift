//
//  EnvironmentService.swift
//  BaseProject
//
//  Created by Tim Walpole on 06/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Foundation

class EnvironmentService: NSObject {

  static func getValueForKey(key: String!) -> String {
    let path =  Bundle.main.path(forResource: "Info", ofType: "plist")
    var dict = NSDictionary(contentsOfFile: path!)
    dict = dict?.value(forKey: "Custom Values") as? NSDictionary
    return dict?.object(forKey: key) as? String ?? ""
  }
}
