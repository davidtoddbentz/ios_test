//
//  NSNumber+Formatting.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 24/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit

extension NSNumber {
    func kFormatNumber(with formatter: NumberFormatter) -> String {
        
        var num = Double(self)
        var postfix = ""
        if num >= 1_000_000 {
            num /= 1_000_000.0
            postfix = "m"
        } else if num >= 1_000 {
            num /= 1_000.0
            postfix = "k"
        }
        
        if let number = NumberFormatter().number(from: String(format: "%.1f", num)),
            let str = formatter.string(from: number) {
        
            return "\(str)\(postfix)"
        } else {
            return "\(self)"
        }
    }
}
