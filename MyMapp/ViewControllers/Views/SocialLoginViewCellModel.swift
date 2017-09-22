//
//  SocialLoginViewCellModel.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 25/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import SwiftyJSON

class SocialLoginViewCellModel: JSONConstruable {
    var title: String = ""
    var image: UIImage?
    var url: String = ""
    var description: String = ""
    var descriptionTheme: String?
    var titleTheme: String?
    
    required init(json: JSON) {
        
        self.description = json[ "description" ].stringValue
        self.descriptionTheme = json[ "descriptionTheme" ].string
        self.title = json[ "title" ].stringValue
        self.titleTheme = json[ "titleTheme" ].string
        self.url = json[ "url" ].stringValue
        self.image = UIImage(named: self.url)
    }
}
