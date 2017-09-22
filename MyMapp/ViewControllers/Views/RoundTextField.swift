//
//  RoundTextField.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {

    override var bounds: CGRect {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = bounds.size.height/2.0
        }
    }
}
