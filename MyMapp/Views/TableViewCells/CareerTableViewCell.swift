//
//  CareerTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 28/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class CareerTableViewCell: UITableViewCell, HeaderedTableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var employmentFillView: FillView!
    @IBOutlet weak var ratingFillView: FillView!
    @IBOutlet weak var educationFillView: FillView!
    @IBOutlet weak var avgSalaryFillView: FillView!
    @IBOutlet weak var growthFillView: FillView!
    @IBOutlet weak var titleLabel: UILabel!
    var career: Career!
    
    var setupComplete = false
    
    func setupView(_ career: Career) {
        self.career = career
        employmentFillView.fillType = .employment
        employmentFillView.value = career.employment
        
        ratingFillView.fillType = .rating
        ratingFillView.value = career.interestRating
        
        var education = career.education
        let index = education?.index((education?.startIndex)!, offsetBy: 4)
        education = education?.substring(to: index!).appending(".")
        educationFillView.value = education
        
        avgSalaryFillView.fillType = .avgSalary
        avgSalaryFillView.value = career.averageSalary
        
        growthFillView.fillType = .growth
        growthFillView.value = career.growth
        
        titleLabel.text = career.jobTitle
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
            
            employmentFillView.titleLabel.text = "EMPLOYMENT"
            ratingFillView.titleLabel.text = "RATING"
            educationFillView.titleLabel.text = "EDUCATION"
            avgSalaryFillView.titleLabel.text = "AVG SALARY"
            growthFillView.titleLabel.text = "GROWTH"
            setupComplete = true
        }
    }
}
