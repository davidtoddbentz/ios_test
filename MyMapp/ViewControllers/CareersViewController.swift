//
//  CareersViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 29/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift
import Cartography
import AVFoundation

class CareersViewController: BaseViewController, SwipeableCardDelegate {
    
    @IBOutlet var swipeableView: ZLSwipeableView!
    
    var colors = [UIColor.rnsSokanuRed,
                  UIColor.rnsSwipeCardBlue,
                  UIColor.rnsSwipeCardGreen,
                  UIColor.rnsWildStrawberry]
    var colorIndex = 0
    var cardIndex = 0
    var currentPlayer: AVPlayer?
    var currentCardID: String?
    var actionCards = [ActionCard]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swipeableView.allowedDirection = .Horizontal
        
        swipeableView.didSwipe = {view, direction, vector in
            self.didSwipeCard(view, direction: direction)
        }
        swipeableView.didTap = {view, location in
            if let topView = self.swipeableView.topView(), let player = (topView.subviews.first as? CardView)?.player {
                if #available(iOS 10.0, *) {
                    if player.timeControlStatus == .paused {
                        player.play()
                    } else {
                        player.pause()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        FireBaseSynchroniser.sharedSynchroniser.actionCards(chosenOnly: false) { (actionCards) in
            if let a = actionCards {
                self.actionCards = a
                self.cardIndex = 0
                self.swipeableView.numberOfActiveView = 5
                self.swipeableView.nextView = {
                    return self.nextCardView()
                }
                if let topView = self.swipeableView.topView(), let player = (topView.subviews.first as? CardView)?.player {
                    player.play()
                }
            }
        }
    }
    
    func didSwipeCard(_ view: UIView, direction: Direction) {
        if let content = view.subviews.first, let id = (content as? CardView)?.id {
            if direction == .Right {
                FireBaseSynchroniser.sharedSynchroniser.actionCardWithID(id)
            }
            (content as? CardView)?.player?.pause()
        }
        if let topView = swipeableView.topView(), let player = (topView.subviews.first as? CardView)?.player {
            player.play()
        }
    }
    
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }
        if cardIndex >= actionCards.count {
            return nil
        }
            
        let actionCard = actionCards[cardIndex]
        cardIndex += 1
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.white
        
        
        let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! CardView
        contentView.backgroundColor = cardView.backgroundColor
        contentView.clipsToBounds = true
        contentView.careerLabel.text = actionCard.job
        contentView.title.text = actionCard.title
        contentView.id = actionCard.id
        
        cardView.addSubview(contentView)
        contentView.bottomView.backgroundColor = colors[colorIndex]
        contentView.delegate = self
        contentView.swipeableView = self.swipeableView
        
        
        if let url = actionCard.videoURL, let videoURL = NSURL(string: url) {
            
            contentView.player = AVPlayer(url: videoURL as URL)
            let playerLayer = AVPlayerLayer(player: contentView.player)
            
            currentPlayer = contentView.player
            playerLayer.frame = CGRect(x: 0, y: 0, width: contentView.imgViewVideo.frame.width, height: contentView.imgViewVideo.frame.height)
            playerLayer.videoGravity = kCAGravityResizeAspectFill
            contentView.contentMode = .scaleAspectFill
            contentView.imgViewVideo.layer.addSublayer(playerLayer)
        } else if let thumbnail = actionCard.thumbnail, let url = URL(string: thumbnail) {
            contentView.imgViewVideo.sd_setImage(with: url)
        }

        
        colorIndex += 1
        constrain(contentView, cardView) { view1, view2 in
            view1.left == view2.left
            view1.top == view2.top
            view1.width == cardView.bounds.width
            view1.height == cardView.bounds.height
        }
        
        return cardView
    }
    
}
