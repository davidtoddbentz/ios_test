//
//  SocialLoginViewModel.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 25/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import Foundation
import SwiftyJSON


class SocialLoginViewModel: JSONConstruable {

  var items = [SocialLoginViewCellModel]()

  required init?(json: JSON) {
    
    if let itemList = json[ "images" ].array {
      for item in itemList {
        let newItem = SocialLoginViewCellModel(json: item)
        self.items.append(newItem)
      }
    }
  }
  
 convenience init?(file: String) {

    let path = Bundle.main.path(forResource: file, ofType: "json")
    let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!))
    let json = JSON(data: jsonData!)
    self.init(json: json)
  }
}
