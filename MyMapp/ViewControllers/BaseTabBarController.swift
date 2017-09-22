//
//  BaseTabBarController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 01/12/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Cartography

class BaseTabBarController: UITabBarController, MenuViewDelegate {
    
    var menuView: MenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tab0 = self.tabBar.items?[0]
        tab0?.selectedImage = #imageLiteral(resourceName: "tabBarRoadmapSelected").withRenderingMode(.alwaysOriginal)
        tab0?.image = #imageLiteral(resourceName: "tabBarRoadmapDeselected").withRenderingMode(.alwaysOriginal)
        
        let tab1 = self.tabBar.items?[1]
        tab1?.selectedImage = #imageLiteral(resourceName: "tabBarCareersSelected").withRenderingMode(.alwaysOriginal)
        tab1?.image = #imageLiteral(resourceName: "tabBarCareersDeselected").withRenderingMode(.alwaysOriginal)
        
        let tab2 = self.tabBar.items?[2]
        tab2?.selectedImage = #imageLiteral(resourceName: "tabBarChatSelected").withRenderingMode(.alwaysOriginal)
        tab2?.image = #imageLiteral(resourceName: "tabBarChatDeselected").withRenderingMode(.alwaysOriginal)
        
        let tab3 = self.tabBar.items?[3]
        tab3?.selectedImage = #imageLiteral(resourceName: "tabBarInfoSelected").withRenderingMode(.alwaysOriginal)
        tab3?.image = #imageLiteral(resourceName: "tabBarInfoDeselected").withRenderingMode(.alwaysOriginal)
        
        let tab4 = self.tabBar.items?[4]
        tab4?.selectedImage = #imageLiteral(resourceName: "tabBarProfileSelected").withRenderingMode(.alwaysOriginal)
        tab4?.image = #imageLiteral(resourceName: "tabBarProfileDeselected").withRenderingMode(.alwaysOriginal)
        
        setupMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UserDefaults.standard.value(forKey: "firstLaunch"))
        if UserDefaults.standard.value(forKey: "firstLaunch") == nil {
            self.selectedViewController?.tabBarController?.selectedIndex = 7
        }
    }
    
    func setupMenu() {
        
        self.tabBar.isHidden = true
        let buttons = [
            ("Roadmap", #imageLiteral(resourceName: "roadmapMenu")),
            ("Careers", #imageLiteral(resourceName: "careersMenu")),
            ("Profile", #imageLiteral(resourceName: "profileMenu")),
            ("Colleges", #imageLiteral(resourceName: "collegesMenu")),
            ("Info", #imageLiteral(resourceName: "infoMenu"))
        ]
        menuView = MenuView(frame: self.tabBar.frame, subMenus: buttons)
        
        if let menuView = menuView {
            self.view.addSubview(menuView)
            menuView.delegate = self
            let views = ["menuView": menuView]
            menuView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[menuView]-0-|", options: [], metrics: nil, views: views)
            menuView.heightConstraint = NSLayoutConstraint(item: menuView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -72)
            let verticalConstraint = NSLayoutConstraint(item: menuView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 380)
            var constraints = horizontalConstraints + [verticalConstraint]
            if let height = menuView.heightConstraint {
                constraints.append(height)
            }
            NSLayoutConstraint.activate(constraints)
            
            menuView.chatButton.setImage(#imageLiteral(resourceName: "chatMenu"), for: .normal)
            menuView.mainMenuButton.setImage(#imageLiteral(resourceName: "mainMenu"), for: .normal)
            
        }
    }
    
    func didSelectMenuItem(atIndex index: Int) {
        if index >= 0 {
            self.selectedViewController?.tabBarController?.selectedIndex = index
        }
    }
    
}
