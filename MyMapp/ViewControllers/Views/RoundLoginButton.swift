//
//  RoundButton.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 27/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

protocol LoginActionDelegate: class {
    func signIn(_ sender: Any?)
    func signUp(_ sender: Any?)
    func skipLogin(_ sender: Any?)
}

class RoundButton: UIButton {

    override var bounds: CGRect {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = bounds.size.height/2.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = imageView?.image {
            
            let margin = bounds.size.height/2.0 - image.size.width / 2
            let titleRects = titleRect(forContentRect: bounds)
            let titleOffset = (bounds.width - titleRects.width - image.size.width - margin) / 2
            
            contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            imageEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: titleOffset, bottom: 0, right: 0)
        }
        
    }
}


class RoundLoginButton: RoundButton {
    
    var provider: AuthenticationProviderName = .Undefined {
        didSet {
            self.updateUI(with: provider)
        }
    }
    
    weak var delegate: LoginActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.commonInit()
    }
    
    func commonInit() {
        self.updateTarget()
        self.provider = .Undefined
    }
    
    func updateUI(with provider: AuthenticationProviderName) {
        
        if provider != .Undefined {
            self.setTitle(provider.rawValue, for: .normal)
            let image = UIImage(named: provider.rawValue)
            self.setImage(image, for: .normal)
            //self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        } else {
            self.setTitle("Skip", for: .normal)
        }
        
        
    }
    
    func updateTarget() {
        self.addTarget(self, action: #selector(self.signIn(_:)), for: .touchUpInside)
    }
    
    func signIn(_ sender: Any?) {
        
        let authProvider = AmazonClientManager.sharedInstance.authenticationProvider(with: self.provider)
        
        if provider == .Undefined {
            self.delegate?.skipLogin(self)
            return
        }
        
        if provider == .Cognito {
            self.delegate?.signIn(self)
            return
        }
        
        if let authCredentialProvider = authProvider as? CredentialAuthenticationProviding {
            AmazonClientManager.sharedInstance.showLogin(authProvider: authCredentialProvider, from: self.parentViewController)
        } else {
            authProvider?.startSession()
        }
    }
}
