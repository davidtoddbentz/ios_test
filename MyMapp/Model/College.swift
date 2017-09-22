//
//  College.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 12/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit

class College: NSObject {
    var schoolName: String?
    var schoolLocation: String?
    
    var inStateTuition: String?
    var outOfStateTuition: String?
    var studentBodySize: String?
    var graduationRate: String?
    var schoolRank: String?
    
    var schoolSentiment: String?
    var acceptanceRate: String?
    var averageHSGPA: String?
    var satACTScorePLX: String?
    var satACTScoreSC: String?
    var webURLPlexuss: String?
    var webURLCollegeConfidential: String?
    
    var keyTopic1: String?
    var keyTopic2: String?
    var keyTopic3: String?
    var isFavourite: Bool
    
    override init() {
        self.isFavourite = false
        super.init()
    }
    
}
