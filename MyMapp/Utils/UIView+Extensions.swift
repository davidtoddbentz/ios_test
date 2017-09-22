//
//  UIView+Extensions.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
