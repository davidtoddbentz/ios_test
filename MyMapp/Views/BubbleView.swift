//
//  BubbleView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 24/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    var label: UILabel
    
    init(color: UIColor, fontColor: UIColor, text: String, radius: CGFloat, font: UIFont) {
        let frame = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
        label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.font = font
        label.textColor = fontColor
        label.textAlignment = .center
        label.text = text
        super.init(frame: frame)
        self.backgroundColor = color
        self.layer.cornerRadius = radius
        self.addSubview(label)
    }
    
    func update(color: UIColor, fontColor: UIColor, text: String, radius: CGFloat, font: UIFont) {
        let frame = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
        label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.font = font
        label.textColor = fontColor
        label.textAlignment = .center
        label.text = text
        self.backgroundColor = color
        self.layer.cornerRadius = radius
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)
    }
    

}
