//
//  InterstitialView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 29/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import ApiAI

class InterstitialView: UIView, UIScrollViewDelegate {
    
    
    let titles = [
        "Brian downloads MyMapp app",
        "Brian selects avatar for his personal assistant.",
        "‘David’ is now added into Brian’s contact.",
        "Brian watches Roadtrip videos.",
        "Brian adds careers to his list.",
        "Brian ticks one of the Action cards off.",
        "Later, Brian is on Facebook.",
        "Brian watches more videos.",
        "Brian receives message on Facebook.",
        "Brian’s parents are involved.",
        "The Digital Assistant follows up with Brian.",
        "Brian completes Sokanu Welcome Assessment.",
        "Brian unlocks the History & Goals Assessment.",
        "Brian completes the Personality Assessment.",
        "Brian receives Badge Award Notification.",
        "The Digital Assistant sends email to counselor.",
        "Brian’s counselor recieves an email.",
        "The counselor reviews the links.",
        "The Digital Assistant suggests a meeting."
    ]
    let subtitles = [
        "Brian sees his friend post on Facebook about how awesome MyMapp app is. He clicks on the link and downloads the app.",
        "Now Brian can chat with ‘David’, his intelligent personal assistant about his career journey 24/7.",
        "‘David’ can be reached via this app, iMessage, and Facebook Messenger.",
        "Brian watches several of the videos from RTN.",
        "Brian eventually adds 3 of the careers to his ‘possible careers’ list.",
        "Brian removes one of the Action cards off his ‘to-do’ list",
        "An hour later his Digital Assistant gets in touch when Brian is on Facebook.",
        "Brian watches several of the videos from RTN and Sokanu organised by interest as defined by social data analysis.",
        "Digital Assistant gets in touch when Brian is on Facebook.",
        "The Digital assistant sends an email to Brian’s parents telling them Brian has been thinking about some career options.",
        "The next day the Digital Assistant asks Brian if he talked with his parents last night.",
        "Brian completes the Welcome Assessment and sees an initial list of possible careers. ",
        "Brian completes the History & Goals Assessment and the other Interests Assessment.",
        "Brian also looks at his Traits, Personality and Archetype Reports.",
        "Brian is awarded the ‘Know Yourself’ badge which is displayed on his APP Profile.",
        "The Digital Assistant sends an email to Brian’s counselor telling him that Brian has been exploring various career options. It includes Brian’s Trait, Personality and Archetype reports and links to the suggested careers.",
        "Brian’s counselor receives an email notification from the Digital Assistant with a link to the integrated LMS. The counselor can see that Brian has completed the assessments on Sokanu. ",
        "The Digital Assistant suggests to the counselor that Brian is introduced to some suitable training content on Student Connections and provides links for him to review.",
        "The Digital Assistant suggests a meeting between the counselor and Brian. The counselor schedules it."
    ]
    
    let images = [
        #imageLiteral(resourceName: "int1"),
        #imageLiteral(resourceName: "int2"),
        #imageLiteral(resourceName: "int3"),
        #imageLiteral(resourceName: "int4"),
        #imageLiteral(resourceName: "int5"),
        #imageLiteral(resourceName: "int6"),
        #imageLiteral(resourceName: "int7"),
        #imageLiteral(resourceName: "int8"),
        #imageLiteral(resourceName: "int9"),
        #imageLiteral(resourceName: "int10"),
        #imageLiteral(resourceName: "int11"),
        #imageLiteral(resourceName: "int12"),
        #imageLiteral(resourceName: "int13"),
        #imageLiteral(resourceName: "int14"),
        #imageLiteral(resourceName: "int15"),
        #imageLiteral(resourceName: "int16"),
        #imageLiteral(resourceName: "int17"),
        #imageLiteral(resourceName: "int18"),
        #imageLiteral(resourceName: "int19")
        
    ]
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagingIndicator: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        let v = Bundle.main.loadNibNamed("InterstitialContentView", owner: self, options: nil)?.first as! UIView
        v.frame = self.frame
        v.setNeedsLayout()
        v.updateConstraints()
        self.addSubview(v)
        let screenCount = titles.count
        pagingIndicator.numberOfPages = screenCount
        
        
        self.scrollView.isPagingEnabled = true
        var f = self.scrollView.frame
        f.size.width = self.view.frame.width
        self.scrollView.frame = f
        self.scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(screenCount), height: scrollView.bounds.height)
        
        for (index, title) in titles.enumerated() {
            var frame = scrollView.bounds
            frame.origin.x += CGFloat(index) * scrollView.bounds.width
            let page = UIView(frame: frame)
            
            
            frame = CGRect(x: 25, y: 0, width: scrollView.frame.width - 50, height: 222)
            let img = UIImageView(frame: frame)
            img.image = images[index]
            img.contentMode = .scaleAspectFit
            page.addSubview(img)
            
            frame = CGRect(x: 25, y: 300.0, width: scrollView.frame.width - 50, height: 150.0)
            let titleLabel = UILabel(frame: frame)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            
            let subtitle = subtitles[index]
            let string = "\(title)\n\n\(subtitle)"
            
            let mainFont = UIFont(name: "Ubuntu-Bold", size: 17.0)!
            let mainColor = UIColor.rnsWildStrawberry
            let rangeSubtitle = (string as NSString).range(of: subtitle)
            
            let attributedString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName: mainFont,
                                                                                          NSForegroundColorAttributeName: mainColor])
            
            let secondaryFont = UIFont(name:"Ubuntu", size: 15.0)!
            let secondaryColor = UIColor.init(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            
            attributedString.addAttributes([NSFontAttributeName: secondaryFont,
                                            NSForegroundColorAttributeName: secondaryColor],
                                           range: rangeSubtitle)
            titleLabel.attributedText = attributedString
            page.addSubview(titleLabel)
            scrollView.addSubview(page)
            
        }
        
    }
}

extension InterstitialView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        let request = apiai.textRequest()
        let text = "Send Interstitial \(page)"
        request?.query = [text]
        request?.requestContexts = [AIRequestContext.init(name: "userNameSet", andParameters: ["name":User.sharedUser.name])]
        apiai.enqueue(request)
        
        pagingIndicator.currentPage = page
    }
}
