//
//  UIWindow+Extension.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 28/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewController(from: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewController(from viewController: UIViewController?) -> UIViewController? {
        
        if let navigationController = viewController as? UINavigationController {
            
            return UIWindow.getVisibleViewController(from: navigationController.visibleViewController)
            
        } else if let tabBarController = viewController as? UITabBarController {
            
            return UIWindow.getVisibleViewController(from: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = viewController?.presentedViewController {
                
                return UIWindow.getVisibleViewController(from: presentedViewController)
                
            } else {
                
                return viewController
            }
        }
    }
}
