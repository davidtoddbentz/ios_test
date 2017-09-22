//
//  ProfileViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 29/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + 123.0)
        self.scrollView.setContentOffset(bottomOffset, animated: false)
        
    }
    
    @IBAction func roadmapButtonTouched(_ sender: Any) {
        let badgeView = BadgeView(frame: self.view.frame)
        badgeView.badgeType = .roadTripNation
        self.view.addSubview(badgeView)
    }
    
    @IBAction func careerstarterButtonTouched(_ sender: Any) {
        let badgeView = BadgeView(frame: self.view.frame)
        badgeView.badgeType = .careerStarter
        self.view.addSubview(badgeView)
    }
    
    @IBAction func goalsetterButtonTouched(_ sender: Any) {
        let badgeView = BadgeView(frame: self.view.frame)
        badgeView.badgeType = .goalSetter
        self.view.addSubview(badgeView)
    }
    
    @IBAction func interestingInterestsButtonTouched(_ sender: Any) {
        let badgeView = BadgeView(frame: self.view.frame)
        badgeView.badgeType = .interestinInterests
        self.view.addSubview(badgeView)
    }
}
