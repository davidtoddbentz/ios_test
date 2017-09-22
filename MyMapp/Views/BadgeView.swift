//
//  BadgeView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 29/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

protocol BadgeViewDelegate {
    func didTouchCompletionButton()
}

enum BadgeType: String {
    case roadTripNation
    case knowYourself
    case careerStarter
    case goalSetter
    case interestinInterests
}

let texts: [String: String] = [BadgeType.roadTripNation.rawValue: "You just earned the ‘RoadTripper’ badge for defining your roadmap.\n\n Keep collecting badges along your journey!",
             BadgeType.knowYourself.rawValue: "You just earned the ‘Know Yourself’ badge for finding out more about your interests.\n\nKeep collecting badges along your journey!",
             BadgeType.careerStarter.rawValue: "You just earned the ‘Career Starter’ badge for creating your career list.\n\nKeep collecting badges along your journey!",
             BadgeType.goalSetter.rawValue: "You just earned the ‘Goal Setter’ badge for setting some real targets.\n\nKeep collecting badges along your journey!",
             BadgeType.interestinInterests.rawValue: "You just earned the ‘Interesting Interests’ badge for finding out more about your interests.\n\nKeep collecting badges along your journey!"
            ]

class BadgeView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var button: UIButton!
    var vc: UIViewController!
    var delegate: BadgeViewDelegate!
    var blurEffectView: UIVisualEffectView!
    
    var badgeType: BadgeType! {
        didSet {
            setupBadge()
        }
    }
    
    override init(frame: CGRect) {
        var f = frame
        f.size.width -= 20
        f.size.height -= 20
        f.origin = CGPoint(x: 10, y: 10)
        super.init(frame: f)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setBlurEffect() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.layer.cornerRadius = 10.0
        blurEffectView.layer.cornerRadius = 10.0
        
        
        self.addSubview(blurEffectView)
    }
    
    func setup() {
        vc = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        if vc is UITabBarController {
            vc = (vc as! UITabBarController).selectedViewController
        }
        setBlurEffect()
        
        
        
        let v = Bundle.main.loadNibNamed("BadgeView", owner: self, options: nil)?.first as! UIView
        self.backgroundColor = UIColor.clear
        v.clipsToBounds = true
        v.backgroundColor = UIColor.clear
        v.frame = self.frame
        self.addSubview(v)
        view.layer.cornerRadius = 10.0
        
    }
    
    func setupBadge() {
        var str = ""
        if let message = texts[badgeType!.rawValue] {
            str = "Congratulations!\n\n\(message)"
        }
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu-Light", size: 18.0)! ]
        let range = (str as NSString).range(of: "Congratulations!")
        let attributedString = NSMutableAttributedString(string: str, attributes: myAttribute)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Ubuntu-Bold", size: 22.0)!, range: range)
        text.attributedText = attributedString
        
        
        switch badgeType! {
        case .roadTripNation:
            image.image = #imageLiteral(resourceName: "roadmapBadge")
            button.setBackgroundImage(#imageLiteral(resourceName: "roadmapButton"), for: .normal)
        case .knowYourself:
            image.image = #imageLiteral(resourceName: "knowyourselfBadge")
            button.setBackgroundImage(#imageLiteral(resourceName: "knowyourselfButton"), for: .normal)
        case .careerStarter:
            image.image = #imageLiteral(resourceName: "careerstarterBadge")	
            button.setBackgroundImage(#imageLiteral(resourceName: "careerstarterButton"), for: .normal)
        case .goalSetter:
            image.image = #imageLiteral(resourceName: "goalSetterBadge")
            button.setBackgroundImage(#imageLiteral(resourceName: "goalSetterButton"), for: .normal)
        case .interestinInterests:
            image.image = #imageLiteral(resourceName: "interestingBadge")
            button.setBackgroundImage(#imageLiteral(resourceName: "interestingButton"), for: .normal)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.vc.tabBarController?.tabBar.isHidden = true
            self.alpha = 1.0
        })
    }
    
    @IBAction func didTouchDismissButton(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.vc.tabBarController?.tabBar.isHidden = false
            self.alpha = 0.0
        }, completion: { (_) in
            self.removeFromSuperview()
            if let delegate = self.delegate {
                self.delegate.didTouchCompletionButton()
            }
        })
    }
}
