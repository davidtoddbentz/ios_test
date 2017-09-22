//
//  RoadmapTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 24/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class RoadmapTableViewCell: UITableViewCell, HeaderedTableViewCell {
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var setupComplete = false
    
    func setupView(_ leader: Leader) {
        jobTitle.text = leader.profession
        name.text = leader.name
        company.text = leader.company
        if let profilePicture = leader.profilePicture {
            avatar.sd_setImage(with: URL(string: profilePicture)!)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !setupComplete {
            let path = UIBezierPath(roundedRect:header.bounds,
                                    byRoundingCorners:[.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
            
            let maskLayer = CAShapeLayer()
            
            background.layer.cornerRadius = 10.0
            background.layer.shadowColor = UIColor.gray.cgColor
            background.layer.shadowRadius = 4.0
            background.layer.shadowOpacity = 0.8
            background.layer.shadowOffset = CGSize(width: 1, height: 1)
            maskLayer.path = path.cgPath
            header.layer.mask = maskLayer
            header.clipsToBounds = true
            setupComplete = true
        }
    }
}
