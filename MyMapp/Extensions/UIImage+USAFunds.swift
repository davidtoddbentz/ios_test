//
//  UIImage+USAFunds.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 31/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import Foundation

extension UIImage {
    
    func scaledToFit(_ newSize: CGSize) -> UIImage{
        let origWidth = self.size.width
        let origHeight = self.size.height
        var newWidth = newSize.width
        var newHeight = newSize.height
        
        if (origWidth / newWidth > origHeight / newHeight) {
            newHeight = origHeight * (newWidth / origWidth)
        } else {
            newWidth = origWidth * (newHeight / origHeight)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newWidth, height: newHeight)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
