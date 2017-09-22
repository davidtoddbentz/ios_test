//
//  LeaderDetailsViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 24/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

class LeaderDetailsViewController: BaseViewController {
    
    var leader: Leader?
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var nameAndCompany: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var bubbleFoundation: BubbleView!
    @IBOutlet weak var bubbleInterest1: BubbleView!
    @IBOutlet weak var bubbleInterest2: BubbleView!
    @IBOutlet weak var biography: UITableView!
    @IBOutlet weak var bioTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videosScrollView: UIScrollView!
    
    var didUpdateUI = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didUpdateUI {
            setupBubbles()
            setupInfo()
            setupVideoScrollView()
            biography.rowHeight = UITableViewAutomaticDimension
            biography.estimatedRowHeight = 59
            self.biography.reloadData()
            setupTableViewHeight()
        }
        didUpdateUI = true
    }
    
    func setupTableViewHeight() {
        biography.backgroundColor = UIColor.red
        self.biography.reloadData()
        DispatchQueue.main.async {
            self.bioTableViewHeight.constant = self.biography.contentSize.height
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupInfo() {
        if let name = leader?.name {
            nameAndCompany.text = name
            if let company = leader?.company {
                nameAndCompany.text?.append(" \(company)")
                let str = nameAndCompany.text!
                let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 25.0)! ]
                let range = (str as NSString).range(of: company)
                let attributedString = NSMutableAttributedString(string: str, attributes: myAttribute)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Ubuntu-Light", size: 25.0)!, range: range)
                nameAndCompany.attributedText = attributedString
            }
        }
        if let prof = leader?.profession {
            profession.text = prof
        }
        if let profilePicture = leader?.profilePicture {
            let url = URL(string: profilePicture as String)
            self.avatar.sd_setImage(with: url)
        }
        
        if let quote = leader?.quote {
            self.quote.text = quote
        }
        
        
    }
    
    func setupBubbles() {
        let font = UIFont(name: "Cubano-regular", size: 13.0)
        let radius = bubbleFoundation.bounds.width / 2.0
        let fontColor = UIColor.white
        var color = UIColor.rnsWildStrawberry
        var text = "Being Creative"
        bubbleFoundation.update(color: color, fontColor: fontColor, text: text, radius: radius, font: font!)
        
        color = UIColor.rnsCerulean
        text = "Design"
        bubbleInterest1.update(color: color, fontColor: fontColor, text: text, radius: radius, font: font!)
        
        color = UIColor.rnsWebOrange
        text = "Art"
        bubbleInterest2.update(color: color, fontColor: fontColor, text: text, radius: radius, font: font!)
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func playVideo(sender: Any) {
        if let button = sender as? UIButton {
            
            let url = URL(string: (leader?.videos![button.tag].manifestURL)!)
            let player = AVPlayer(url: url!)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC, animated: true) {
                playerVC.player?.play()
            }
            
        }
    }
    
    
    func setupVideoScrollView() {
        guard let videos = leader?.videos else { videosScrollView.removeFromSuperview(); return }
        let videosCount = videos.count
        
        videosScrollView.isPagingEnabled = true
        videosScrollView.contentSize = CGSize(width: videosScrollView.bounds.width * CGFloat(videosCount), height: 200.0)
        
        for (index, video) in videos.enumerated() {
            var frame = videosScrollView.bounds
            frame.origin.x += CGFloat(index) * videosScrollView.frame.width
            let view = UIView(frame: frame)
            let imgView = UIImageView(frame: CGRect(x: 26, y: 0, width: view.bounds.width - 2 * 26, height: 184))
            imgView.sd_setImage(with: URL(string: video.thumbURL!))
            view.addSubview(imgView)
            videosScrollView.addSubview(view)
            
            if let title = video.title, let duration = video.duration {
                let label = UILabel(frame: CGRect(x: 26, y: view.bounds.height - 20.0, width: imgView.bounds.width, height: 20))
                let (_, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: duration)
                let time = String(format:"(%d:%02d)", minutes, seconds)
                label.text = "\(title) \(time)"
                
                let str = label.text!
                let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 12.0)! ]
                let range = (str as NSString).range(of: time)
                let attributedString = NSMutableAttributedString(string: str, attributes: myAttribute)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Ubuntu-Light", size: 12.0)!, range: range)
                label.attributedText = attributedString
                
                view.addSubview(label)
            }
            
            let button = UIButton(frame: view.bounds)
            button.tag = index
            button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            view.addSubview(button)
        }
        
    }
}

extension LeaderDetailsViewController: MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView {
        return self.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let headerN = UIView()
        headerN.backgroundColor = UIColor.rnsMalachite
        return headerN
    }
}

extension LeaderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bio = leader?.biography {
            return bio.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBioTableViewCell", for: indexPath) as! LeaderBioTableViewCell
        if let str = leader?.biography?[indexPath.row] {
            cell.setupCell(str)
        }
        return cell
    }
    
}
