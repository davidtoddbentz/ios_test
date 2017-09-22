//
//  CollegeTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 12/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import SDWebImage

protocol CollegeTableViewCellDelegate {
    func didTouchFavouriteButton()
}

class CollegeTableViewCell: UITableViewCell, HeaderedTableViewCell {
    
    enum LabelType {
        case inStateTuition
        case outStateTuition
        case studentBodySize
        case graduationRate
        case schoolSentiment
        case acceptanceRate
        case averageGPA
        case satActScore
    }
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var inStateTuition: UILabel!
    @IBOutlet weak var outStateTuition: UILabel!
    @IBOutlet weak var studentBodySize: UILabel!
    @IBOutlet weak var graduationRate: UILabel!
    @IBOutlet weak var admissionDeadline: UILabel!
    @IBOutlet weak var acceptanceRate: UILabel!
    @IBOutlet weak var averageGPA: UILabel!
    @IBOutlet weak var satActScore: UILabel!
    @IBOutlet weak var sentimentImgView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var keyTopic1: UIButton!
    @IBOutlet weak var keyTopic2: UIButton!
    @IBOutlet weak var keyTopic3: UIButton!
    @IBOutlet weak var labelRank: UILabel!
    
    var setupComplete = false
    var college: College?
    var delegate: CollegeTableViewCellDelegate?
    
    
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
            keyTopic1.setupKeyTopicButton()
            keyTopic2.setupKeyTopicButton()
            keyTopic3.setupKeyTopicButton()
        }
    }
    
    func setupView(_ college: College) {
        self.college = college
        if college.isFavourite == true {
            favouriteButton.setImage(#imageLiteral(resourceName: "heartSelected"), for: .normal)
        } else {
            college.isFavourite = false
            favouriteButton.setImage(#imageLiteral(resourceName: "heartDeselected"), for: .normal)
        }
        
        self.name.text = college.schoolName
        self.location.text = college.schoolLocation
        
        self.inStateTuition.setupCollegeLabel(title: .inStateTuition, data: college.inStateTuition)
        self.outStateTuition.setupCollegeLabel(title: .outStateTuition, data: college.outOfStateTuition)
        self.studentBodySize.setupCollegeLabel(title: .studentBodySize, data: college.studentBodySize)
        self.graduationRate.setupCollegeLabel(title: .graduationRate, data: college.graduationRate)
        
        self.admissionDeadline.setupCollegeLabel(title: .schoolSentiment, data: college.schoolSentiment)
        self.acceptanceRate.setupCollegeLabel(title: .acceptanceRate, data: college.acceptanceRate)
        self.averageGPA.setupCollegeLabel(title: .averageGPA, data: college.averageHSGPA)
        self.satActScore.setupCollegeLabel(title: .satActScore, data: college.satACTScoreSC)
        
        if let topic1 = college.keyTopic1 {
            keyTopic1.setTitle(topic1, for: .normal)
            keyTopic1.titleLabel?.adjustsFontSizeToFitWidth = true
            keyTopic1.titleLabel?.baselineAdjustment = .alignCenters
        }
        if let topic2 = college.keyTopic2 {
            keyTopic2.setTitle(topic2, for: .normal)
            keyTopic2.titleLabel?.adjustsFontSizeToFitWidth = true
            keyTopic2.titleLabel?.baselineAdjustment = .alignCenters
        }
        if let topic3 = college.keyTopic3 {
            keyTopic3.setTitle(topic3, for: .normal)
            keyTopic3.titleLabel?.adjustsFontSizeToFitWidth = true
            keyTopic3.titleLabel?.baselineAdjustment = .alignCenters
        }
        
        if let sentiment = college.schoolSentiment,
            let sentimentDoubleValue = Double(sentiment) {
            
            if sentimentDoubleValue <= -0.2 {
                sentimentImgView.image = #imageLiteral(resourceName: "sentimentUnhappy")
            } else if sentimentDoubleValue > -0.2 && sentimentDoubleValue < 0.2 {
                sentimentImgView.image = #imageLiteral(resourceName: "sentimentAverage")
            } else {
                sentimentImgView.image = #imageLiteral(resourceName: "sentimentSmiley")
            }
        }
        
        if let rank = college.schoolRank {
            self.labelRank.text = "#\(rank)"
        }
        if let url = URL(string: "http://www.rice.edu/_images/feature-why-rice.jpg") {
            photo.sd_setImage(with: url)
        }
    }
    
    @IBAction func didTouchFavouriteButton(_ sender: Any) {
        guard let college = college else { return }
        college.isFavourite = !college.isFavourite
        favouriteButton.setImage(college.isFavourite ? #imageLiteral(resourceName: "heartSelected") : #imageLiteral(resourceName: "heartDeselected"), for: .normal)
        
        FireBaseSynchroniser.sharedSynchroniser.setFavouriteCollege(college)
        delegate?.didTouchFavouriteButton()
    }
    
    
}

extension UIButton {
    func setupKeyTopicButton() {
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.backgroundColor = UIColor.rnsTomato
        self.setTitleColor(UIColor.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension UILabel {
    func setupCollegeLabel(title: CollegeTableViewCell.LabelType, data: String?) {
        let data = data
        var dataValue = "N/A"
        if  data != nil {
            dataValue = data!
        }
        var titleText = ""
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumFractionDigits = 1
        formatter.locale = Locale(identifier: "en-US")
        switch title {
        case .inStateTuition:
            titleText = "In-state Tuition:"
            formatter.numberStyle = .currency
        case .outStateTuition:
            titleText = "Out-state Tuition:"
            formatter.numberStyle = .currency
        case .studentBodySize:
            titleText = "Student Body Size:"
        case .graduationRate:
            titleText = "Graduation Rate:"
        case .schoolSentiment:
            titleText = "School Sentiment:"
            formatter.numberStyle = .decimal
        case .acceptanceRate:
            titleText = "Acceptance Rate:"
        case .averageGPA:
            titleText = "Average GPA:"
        case .satActScore:
            titleText = "SAT/ACT Score:"
        }
        if dataValue != "N/A" {
            if let num = NumberFormatter().number(from: dataValue) {
                let value = num.kFormatNumber(with: formatter)
                dataValue = value
            }
        }
        self.text = "\(titleText) \(dataValue)"
        if let text = self.text {
            let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu-Medium", size: 12.0)! ]
            let attributedString = NSMutableAttributedString(string: text, attributes: myAttribute)
            
            let rangeData = (text as NSString).range(of: dataValue)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(colorLiteralRed: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0), range: rangeData)
            
            let rangeTitle = (text as NSString).range(of: titleText)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(colorLiteralRed: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0), range: rangeTitle)
            self.attributedText = attributedString
            
        }
    }
}
