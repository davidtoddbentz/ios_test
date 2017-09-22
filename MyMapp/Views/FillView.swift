//
//  FillView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 28/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

enum FillType {
    case employment, avgSalary, rating, growth, education
}

class FillView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedBar: UIView!
    @IBOutlet weak var remainingBar: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    var value: String! {
        didSet {
            valueLabel.text = value
            guard let fillType = self.fillType, var val = value else { return }
            val = val.trimmingCharacters(in: NSCharacterSet(charactersIn: "01234567890.").inverted)
            var f = 0.0
            if let n = NumberFormatter().number(from: val) {
                f = Double(n)
            }
            
            var min = 0.0
            var max = 0.0
            switch fillType {
            case .employment:
                min = 0
                max = 300
            case .avgSalary:
                min = 10
                max = 125
            case .rating:
                min = 0
                max = 5
            case .growth:
                min = -10
                max = 20
            default: break
            }
            let fill = (f - min) / (max - min)
            var frame = completedBar.frame
            frame.size.width = CGFloat(fill) * remainingBar.frame.size.width
            completedBar.frame = frame
            
            if fill <= 0.33 {
                completedBar.backgroundColor = UIColor.fillViewRed()
            } else if fill <= 0.66 {
                completedBar.backgroundColor = UIColor.fillViewYellow()
            } else {
                completedBar.backgroundColor = UIColor.fillViewGreen()
            }
        }
    }
    var fillType: FillType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = Bundle.main.loadNibNamed("FillView", owner: self, options: nil)?.first
        if let view = view {
            self.addSubview(view as! UIView)
        }
    }
    
    
}
