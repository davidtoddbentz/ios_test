//
//  UIColor+Zeplin.swift
//  BaseProject
//
//  Created by BJSS on 26/05/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

extension UIColor {
    class func bjssLightBlueGreyColor() -> UIColor {
        return UIColor(red: 18.0 / 255.0, green: 38.0 / 255.0, blue: 50.0 / 255.0, alpha: 0.5)
    }
    
    class func bjssDarkBlueGreyColor() -> UIColor {
        return UIColor(red: 18.0 / 255.0, green: 38.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    }
    
    class func fillViewGreen() -> UIColor {
        return UIColor(red: 1.0 / 255.0, green: 216.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
    
    class func fillViewYellow() -> UIColor {
        return UIColor(red: 254.0 / 255.0, green: 164.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
    }
    
    class func fillViewRed() -> UIColor {
        return UIColor(red: 232.0 / 255.0, green: 63.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
    
    class var lightPastelBlue: UIColor {
        get {
            return UIColor(hexString: "E2BAC5")
        }
    }
    
    class var pastelBlue: UIColor {
        get {
            return UIColor(hexString: "E299B4")
        }
    }
    
    class var darkPastelBlue: UIColor {
        get {
            return UIColor(hexString: "FF44A0")
        }
    }
    
    class var darkBlue: UIColor {
        get {
            return UIColor(hexString: "FF44A0")
        }
    }
    
    class var pastelGray: UIColor {
        get {
            return UIColor(hexString: "E9E7E3")
        }
    }
    
}
