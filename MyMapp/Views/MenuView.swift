//
//  MenuView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 20/12/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func didSelectMenuItem(atIndex index: Int)
}

enum ViewController: Int {
    case badges = 0
    case roadmap = 1
    case careers = 2
    case chat = 3
    case videos = 4
    case profile = 5
    case colleges = 6
    case avatarSelect = 7
}

class MenuView: UIView {
    
    var delegate: MenuViewDelegate?
    
    let buttonDimension = CGFloat(45.0)
    let mainMenuButton: UIButton!
    let chatButton: UIButton!
    var subMenuButtons: [UIButton] = []
    var isMenuPresented = false
    var l = 100.0
    var angle =   Double.pi
    let presentationRadius = 2/3 * Float.pi
    var subMenuConstraintConstants = [CGPoint]()
    var subMenuConstraints = [(NSLayoutConstraint, NSLayoutConstraint)]()
    var heightConstraint: NSLayoutConstraint?
    
    var distMainToTop: NSLayoutConstraint?
    var xCenterMainButton: NSLayoutConstraint?
    
    var distChatToTop: NSLayoutConstraint?
    var xCenterChatButton: NSLayoutConstraint?
    
    var heightDifference = CGFloat(208.0)
    var buttonHeightDifference = CGFloat(114.0)
    
    
    convenience init(frame: CGRect, subMenus: [(title: String, image: UIImage)]) {
        var f = frame
        f.size.height += 380.0
        
        self.init(frame: f)
        
        for i in 0..<subMenus.count {
            let btnData = subMenus[i]
            var f = mainMenuButton.frame
            let button = UIButton(frame: f)
            button.layer.cornerRadius = CGFloat(buttonDimension / 2.0)
            button.setImage(btnData.image, for: .normal)
            button.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
            button.accessibilityIdentifier = btnData.title
            subMenuButtons.append(button)
            let title = UILabel()
            title.text = btnData.title
            title.font = UIFont(name: "Ubuntu-Medium", size: 14.0)
            title.textColor = UIColor.init(colorLiteralRed: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
            button.addSubview(title)
            self.insertSubview(button, belowSubview: mainMenuButton)
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            let constraintX = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: mainMenuButton, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let constraintY = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainMenuButton, attribute: .top, multiplier: 1.0, constant: 0.0)
            let width = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
            let height = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
            let titleConstrainVertical = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: title, attribute: .top, multiplier: 1.0, constant: -2.0)
            let titleCenterX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            
            subMenuConstraints.append((constraintX, constraintY))
            NSLayoutConstraint.activate([constraintX, constraintY, width, height, titleConstrainVertical, titleCenterX])
            
            let center = button.frame
            let ß = (Double.pi - angle) / 2.0 + Double(i) * (angle / Double(subMenus.count - 1))
            let x = Double(center.origin.x) - l * cos(ß)
            let y = Double(center.origin.y) - l * sin(ß)
            
            subMenuConstraintConstants.append(CGPoint(x: x, y: y))
            button.isHidden = true
        }
        
    }
    
    override init(frame: CGRect) {
        
        mainMenuButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: buttonDimension,
                                                height: buttonDimension))
        chatButton = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: buttonDimension,
                                            height: buttonDimension))
        
        mainMenuButton.accessibilityIdentifier = "mainMenuButtonID"
        mainMenuButton.isAccessibilityElement = true
        
        super.init(frame: frame)
        self.setBlurEffect()
        self.addSubview(mainMenuButton)
        self.addSubview(chatButton)
        
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        xCenterMainButton = NSLayoutConstraint(item: mainMenuButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: buttonDimension / 2.0 + 10)
        let width = NSLayoutConstraint(item: mainMenuButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
        let height = NSLayoutConstraint(item: mainMenuButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
        distMainToTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: mainMenuButton, attribute: .top, multiplier: 1.0, constant: -13.0)
        
        xCenterChatButton = NSLayoutConstraint(item: chatButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -(buttonDimension / 2.0 + 10))
        let widthChat = NSLayoutConstraint(item: chatButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
        let heightChat = NSLayoutConstraint(item: chatButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonDimension)
        distChatToTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: chatButton, attribute: .top, multiplier: 1.0, constant: -13.0)
        
        let constraints = [xCenterMainButton,
                           width,
                           height,
                           distMainToTop,
                           xCenterChatButton,
                           widthChat,
                           heightChat,
                           distChatToTop]
        NSLayoutConstraint.activate(constraints as! [NSLayoutConstraint])
        
        mainMenuButton.layer.cornerRadius = buttonDimension / 2.0
        chatButton.layer.cornerRadius = buttonDimension / 2.0
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        mainMenuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
    }
    
    func setBlurEffect() {
        self.backgroundColor = UIColor.clear
        var blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) {
             blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
    
    func didTapMenu(sender: UIButton) {
        
        var shouldEscapeWithoutAnimating = false
        var index = -1
        if sender == chatButton {
            index = ViewController.chat.rawValue
            if isMenuPresented == false {
                shouldEscapeWithoutAnimating = true
            }
        } else if sender == mainMenuButton {
            index = -1
        } else if subMenuButtons.contains(sender) {
            switch subMenuButtons.index(of: sender)! {
            case 0:
                index = ViewController.roadmap.rawValue
            case 1:
                index = ViewController.careers.rawValue
            case 2:
                index = ViewController.profile.rawValue
            case 3:
                index = ViewController.colleges.rawValue
            case 4:
                index = ViewController.videos.rawValue
            default:
                index = -1
            }
        }
        delegate?.didSelectMenuItem(atIndex: index)
        if shouldEscapeWithoutAnimating {
            return
        }
        
        var duration: CGFloat
        var damping: CGFloat
        
        if isMenuPresented {
            duration = 0.35
            damping = 1.0
            heightConstraint?.constant += heightDifference
            distMainToTop?.constant += buttonHeightDifference
            distChatToTop?.constant += heightDifference
            xCenterMainButton?.constant += buttonDimension / 2.0 + 10
            xCenterChatButton?.constant -= buttonDimension / 2.0 + 10
        } else {
            duration = 0.5
            damping = 0.65
            heightConstraint?.constant -= heightDifference
            distMainToTop?.constant -= buttonHeightDifference
            distChatToTop?.constant -= heightDifference
            xCenterMainButton?.constant -= buttonDimension / 2.0 + 10
            xCenterChatButton?.constant += buttonDimension / 2.0 + 10
        }
        
        for i in 0..<self.subMenuButtons.count {
            let button = self.subMenuButtons[i]
            let x = self.isMenuPresented ? -self.subMenuConstraintConstants[i].x : self.subMenuConstraintConstants[i].x
            let y = self.isMenuPresented ? -self.subMenuConstraintConstants[i].y : self.subMenuConstraintConstants[i].y
            self.subMenuConstraints[i].0.constant += x
            self.subMenuConstraints[i].1.constant += y
            button.isHidden = false
        }
        
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: 1.0,
                       options: [],
                       animations: {
                        self.superview?.layoutIfNeeded()
                        for button in self.subMenuButtons {
                            button.alpha = self.isMenuPresented ? 0.0 : 1.0
                        }
        }) { (completed) in
            for button in self.subMenuButtons {
                button.isHidden = self.isMenuPresented ? false : true
            }
        }
        isMenuPresented = !isMenuPresented
    }
    
    
    
}
