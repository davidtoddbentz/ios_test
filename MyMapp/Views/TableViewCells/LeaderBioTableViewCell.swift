//
//  LeaderBioTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 24/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class LeaderBioTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dot.layer.cornerRadius = dot.bounds.width / 2.0
    }
    
    func setupCell(_ string: String) {
        label.text = string
    }
    
    
    
}
