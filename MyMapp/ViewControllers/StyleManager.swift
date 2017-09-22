//
//  StyleManager.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class StyleManager {
    
    class func defaultStyle(label: UILabel) {
        
        label.font = UIFont.labelFont
        label.textColor = UIColor.white
        label.numberOfLines = 1
    }
    
    class func defaultStyle(textField: UITextField) {
        textField.font = UIFont.buttonFont
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.lightPastelBlue
    }
    
    class func defaultStyle(button: UIButton) {
        
        button.titleLabel?.font = UIFont.buttonFont
        button.titleLabel?.textColor = UIColor.black
        button.backgroundColor = UIColor.darkPastelBlue
    }
}
