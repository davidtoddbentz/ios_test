//
//  LoginButtonsView.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 27/09/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit


class LoginButtonsView: UIView {

    var buttons: [UIButton] = []
    
    let spacing: CGFloat = 5.0
    
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: LoginActionDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    func commonInit() {
        
        let providers: [AuthenticationProviderName] = [.Facebook, .Twitter, .Cognito]
        self.build(with: providers)
    }
    
    func build(with providers: [AuthenticationProviderName]) {
    
        let rect = CGRect.zero
        
        let odd = providers.count % 2 != 0
        
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = self.spacing
        
        for (index, provider) in providers.enumerated() {
            
            let button = RoundLoginButton(frame: rect)
            button.provider = provider
            button.delegate = self
            
            if index == 0 {
                button.setTitle("Connect with \(provider.rawValue)", for: .normal)
                button.backgroundColor = UIColor.darkPastelBlue
            } else if index <= 2 {
                button.backgroundColor = UIColor.pastelBlue
            } else {
                button.backgroundColor = UIColor.lightPastelBlue
            }
            button.titleLabel?.font = UIFont.buttonFont
            button.accessibilityIdentifier = provider.rawValue
            
            self.buttons.append(button)
            
            if odd && index == 0 {
                self.stackView.addArrangedSubview(button)
            } else {
                if let hStackView = self.stackView.arrangedSubviews.last as? UIStackView,
                    hStackView.arrangedSubviews.count <= 1 {
                        hStackView.addArrangedSubview(button)
                    
                } else {
                    let hStackView = UIStackView(frame: rect)
                    hStackView.axis = .horizontal
                    hStackView.distribution = .fillEqually
                    hStackView.spacing = self.spacing
                    hStackView.addArrangedSubview(button)
                    self.stackView.addArrangedSubview(hStackView)
                }
            }
        }
    }
    
}

extension LoginButtonsView: LoginActionDelegate {
    
    func signIn(_ sender: Any?) {
        
        self.delegate?.signIn(sender)
    }
    
    func signUp(_ sender: Any?) {
        
        self.delegate?.signUp(sender)
    }
    
    func skipLogin(_ sender: Any?) {
        
       self.delegate?.skipLogin(sender)
    }
}
