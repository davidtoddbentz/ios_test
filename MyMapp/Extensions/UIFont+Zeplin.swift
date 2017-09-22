//
//  UIFont+Zeplin.swift
//  BaseProject
//
//  Created by BJSS on 15/06/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

extension UIFont {

    class var bjssHeaderFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightRegular)
        }
    }
    
    class var buttonFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        }
    }
    
    class var labelFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
        }
    }
}
