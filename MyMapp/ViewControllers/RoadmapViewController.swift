//
//  RoadmapViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 21/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import Foundation
import UIKit
import ApiAI
import Cartography

let foundationsArray = ["Helping People",
                        "Being Physically Active",
                        "Problem Solving",
                        "Accomplishing Goals",
                        "Working Intependently",
                        "Being Creative",
                        "Building Things",
                        "Teaching",
                        "Working with Others",
                        "Communication",
                        "Upholding a Cause and Belief"]
let interestArray = ["Acting",
                     "Action Sports",
                     "Art",
                     "Business",
                     "Design",
                     "Education",
                     "Engineering",
                     "Entrepreneurship",
                     "Environment",
                     "Fashion",
                     "Film",
                     "Food",
                     "Government",
                     "Journalism",
                     "Law",
                     "Medicine",
                     "Music",
                     "Non-profit Organizations",
                     "Numbers",
                     "Philosophy & Religion",
                     "Politics",
                     "Radio",
                     "Science",
                     "Sports",
                     "Technology",
                     "Television",
                     "Travel",
                     "Writing",
                     "Armed Services"]


let questionColors = [UIColor.rnsWildStrawberry,
                      UIColor.rnsCerulean,
                      UIColor.rnsWebOrange,
                      UIColor.black]


let subtitleTexts = ["What lights you up at your core?",
                     "What interests you most?",
                     "What else interests you?",
                     "My road is all about Being Creative while exploring the worlds of Design and Art."
]

let descriptionTexts = ["It doesn't matter what I'm doing as long as I'm...",
                        "I lose track of time when I'm learning about...",
                        "I'm also into...",
                        ""]

var chosenNodes = [String]()

var apiai: ApiAI {
get {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    return (appDelegate?.apiai)!
}
}

enum Question: Int {
    case undefined = -1
    case foundation
    case interest1
    case interest2
    case result
    case tableView
}

class RoadmapViewController: BaseViewController, BLBubbleSceneDataSource, BLBubbleSceneDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foundationCircle: UIView!
    @IBOutlet weak var foundationLabel: UILabel!
    @IBOutlet weak var interest1Circle: UIView!
    @IBOutlet weak var interest1Label: UILabel!
    @IBOutlet weak var interest2Circle: UIView!
    @IBOutlet weak var interest2Label: UILabel!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var DescriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceBetweenNodeAndDescriptionView: NSLayoutConstraint!
    @IBOutlet weak var subtitleHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewConnectedOvals: UIImageView!
    @IBOutlet weak var buttonConnectedOvals: UIButton!
    
    fileprivate var lastSelected: IndexPath! = nil
    fileprivate var leaders = [Leader]()
    fileprivate let transitionManager = MCMHeaderAnimated()
    fileprivate var bubbleScene: BLBubbleScene!
    
    var question: Question = .undefined {
        didSet {
            switch question {
            case .foundation:
                skView.isHidden = false
                setBubbles(titles: foundationsArray)
                interest1Circle.alpha = 0.0
                interest2Circle.alpha = 0.0
            case .interest1:
                skView.isHidden = false
                setBubbles(titles: interestArray)
                interest1Circle.alpha = 1.0
                interest2Circle.alpha = 0.0
            case .interest2:
                skView.isHidden = false
                interest1Circle.alpha = 1.0
                interest2Circle.alpha = 1.0
                setBubbles(titles: interestArray)
            case .result:
                skView.isHidden = false
                setBubbles(titles: [chosenNodes[0], chosenNodes[1], chosenNodes[2]])
                foundationCircle.alpha = 0.0
                interest1Circle.alpha = 0.0
                interest2Circle.alpha = 0.0
            default:
                skView.isHidden = true
                return
            }
            
            subtitleLabel.textColor = questionColors[question.rawValue]
            subtitleLabel.text = subtitleTexts[question.rawValue]
            descriptionLabel.text = descriptionTexts[question.rawValue]
            setupScene()
        }
    }
    
    var bubbles: [Bubble]?
    var color: UIColor?
    
    //MARK: Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        FireBaseSynchroniser.sharedSynchroniser.leaders { (leaders) in
            if let l = leaders {
                self.leaders = l
                self.tableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if question == .undefined {
            question = .foundation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leaderDetailsSegue" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            let leader = self.leaders[lastSelected!.row]
            
            let destination = segue.destination as! LeaderDetailsViewController
            destination.leader = leader
            destination.transitioningDelegate = self.transitionManager
            
            self.transitionManager.destinationViewController = destination
        }
    }
    
    func setupScene() {
        
        let bounds = CGSize(width: self.skView.bounds.size.width * 2,
                            height: self.skView.bounds.size.height)
        bubbleScene = BLBubbleScene(size: bounds)
        bubbleScene.backgroundColor = UIColor.white
        bubbleScene.bubbleDataSource = self
        bubbleScene.bubbleDelegate = self
        bubbleScene.backgroundColor = UIColor.clear
        skView.presentScene(bubbleScene)
        skView.allowsTransparency = true
    }
    
    func setupUI() {
        setupCircleView(circle: foundationCircle)
        foundationLabel.text = "CHOOSE A FOUNDATION"
        foundationLabel.textColor = UIColor.black
        setupCircleView(circle: interest1Circle)
        interest1Label.text = "CHOOSE AN INTEREST"
        interest1Label.textColor = UIColor.black
        setupCircleView(circle: interest2Circle)
        interest2Label.text = "CHOOSE ANOTHER INTEREST"
        interest2Label.textColor = UIColor.black
    }
    
    func setupCircleView(circle: UIView) {
        circle.layer.cornerRadius = circle.bounds.size.width/2.0
        circle.layer.borderColor = UIColor.black.cgColor
        circle.layer.borderWidth = 2.0
        circle.backgroundColor = UIColor.clear
        foundationLabel.textColor = UIColor.black
    }
    
    func setBubbles(titles: [String]) {
        bubbles = []
        for (index, title) in titles.enumerated() {
            let bubble = Bubble(index: index, title: title)
            bubbles?.append(bubble!)
        }
    }
    
    func presentBadgeView() {
        let badgeView = BadgeView(frame: self.view.frame)
        badgeView.badgeType = .roadTripNation
        badgeView.delegate = self
        self.view.addSubview(badgeView)
    }
    
    
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func buttonResetTouched(_ sender: Any) {
        question = .foundation
        chosenNodes = [String]()
        self.DescriptionViewHeight.constant += 50
        self.subtitleHeight.constant = 28.0
        UIView.animate(withDuration: 0.25, animations: {
            self.imageViewConnectedOvals.alpha = 0.0
            self.buttonConnectedOvals.alpha = 0.0
            self.foundationCircle.alpha = 1.0
            self.view.layoutIfNeeded()
        })
        setupUI()
        self.tableView.isHidden = true
    }
    
    //MARK: BubbleView Delegate
    
    func bubbleScene(_ scene: BLBubbleScene, didSelectBubble bubble: BLBubbleNode, at index: Int) {
        if question != .result && question != .tableView {
            chosenNodes.append(bubble.label.text!)
        }
        switch question {
        case .foundation:
            foundationCircle.backgroundColor = questionColors[question.rawValue]
            foundationCircle.layer.borderWidth = 0
            foundationLabel.text = bubble.label.text
            foundationLabel.textColor = UIColor.white
            question = .interest1
        case .interest1:
            interest1Circle.backgroundColor = questionColors[question.rawValue]
            interest1Circle.layer.borderWidth = 0
            interest1Label.text = bubble.label.text
            interest1Label.textColor = UIColor.white
            question = .interest2
        case .interest2:
            interest2Circle.backgroundColor = questionColors[question.rawValue]
            interest2Circle.layer.borderWidth = 0
            interest2Label.text = bubble.label.text
            interest2Label.textColor = UIColor.white
            
            self.DescriptionViewHeight.constant += 300
            let string = "My road is all about \(chosenNodes[0]) while exploring the world of \(chosenNodes[1]) and \(chosenNodes[2])"
            let height = heightForLabel(text: string, font: UIFont(name: "Ubuntu-Bold", size: 18.0)!, width: subtitleLabel.bounds.width)
            self.subtitleHeight.constant = height
            self.distanceBetweenNodeAndDescriptionView.constant -= 400
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            
            question = .result
            let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 18.0)! ]
            let rangeFoundation = (string as NSString).range(of: chosenNodes[0])
            let rangeInterest1 = (string as NSString).range(of: chosenNodes[1])
            let rangeInterest2 = (string as NSString).range(of: chosenNodes[2])
            let attributedString = NSMutableAttributedString(string: string, attributes: myAttribute)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: questionColors[0], range: rangeFoundation)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: questionColors[1], range: rangeInterest1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: questionColors[2], range: rangeInterest2)
            subtitleLabel.attributedText = attributedString
            let request = apiai.textRequest()
            request?.query = "search road trip nation with \(chosenNodes[0]) \(chosenNodes[1]) and \(chosenNodes[2])"
            request?.requestContexts = [AIRequestContext.init(name: "userNameSet", andParameters: ["name":User.sharedUser.name])]
            apiai.enqueue(request)
            
            self.perform(#selector(presentBadgeView), with: self, afterDelay: 2.0)
            
        case .result:
            self.DescriptionViewHeight.constant -= 350
            self.distanceBetweenNodeAndDescriptionView.constant += 400
            self.subtitleLabel.font = UIFont(name: "Ubuntu-Bold", size: 14.0)
            let height = heightForLabel(text: subtitleLabel.text!, font: subtitleLabel.font, width: subtitleLabel.bounds.width)
            self.subtitleHeight.constant = height
            imageViewConnectedOvals.isHidden = false
            buttonConnectedOvals.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.imageViewConnectedOvals.alpha = 1.0
                self.buttonConnectedOvals.alpha = 1.0
                self.view.layoutIfNeeded()
                self.tableView.isHidden = false
                
            })
            question = .tableView
        default:
            break
            
        }
        
    }
    
    
    
    func numberOfBubbles(in scene: BLBubbleScene) -> Int {
        return self.bubbles!.count
    }
    
    func bubbleScene(_ scene: BLBubbleScene, modelForBubbleAt index: Int) -> BLBubbleModel {
        return self.bubbles![index]
    }
    
    
    func bubbleScene(_ scene: BLBubbleScene, bubbleFillColorFor index: Int) -> UIColor? {
        switch question {
        case .result:
            return questionColors[index]
        default:
            return questionColors[question.rawValue]
        }
    }
    
    func bubbleFontName(for scene: BLBubbleScene) -> String {
        return "Cubano-Regular"
    }
    
    func bubbleRadius(for scene: BLBubbleScene) -> CGFloat {
        return 45.0
    }
    
    func bubbleFontSize(for scene: BLBubbleScene) -> CGFloat {
        return 12.0
    }
}

//MARK: TableViewDelegate and TableViewDataSource
extension RoadmapViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoadmapTableViewCell") as! RoadmapTableViewCell
        let leader = leaders[indexPath.row]
        cell.setupView(leader)
        
        return cell
    }
    
    //        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //            return 144.0
    //        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelected = indexPath
        self.performSegue(withIdentifier: "leaderDetailsSegue", sender: nil)
    }
}

extension RoadmapViewController: MCMHeaderAnimatedDelegate {
    func headerView() -> UIView {
        // Selected cell
        let cell = self.tableView.cellForRow(at: self.lastSelected) as! RoadmapTableViewCell
        return cell.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let cell = tableView.cellForRow(at: self.lastSelected) as! RoadmapTableViewCell
        let header = UIView(frame: cell.header.frame)
        header.backgroundColor = UIColor.rnsMalachite
        return header
    }
    
}
extension RoadmapViewController: BadgeViewDelegate {
    func didTouchCompletionButton() {
        bubbleScene(bubbleScene, didSelectBubble: BLBubbleNode(), at: -666)
    }
}
