//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 5/24/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift
import AVFoundation

protocol SwipeableCardDelegate {
    func didSwipeCard(_ view: UIView, direction: Direction)
}

class CardView: UIView {

    
    @IBOutlet weak var imgViewVideo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var careerLabel: UILabel!
    var id: String!
    var player: AVPlayer?
    weak var swipeableView: ZLSwipeableView!
    var delegate: SwipeableCardDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    func stopVideo() {
        player?.pause()
    }
    
    @IBAction func didTouchDislikeButton(_ sender: Any) {
        self.swipeableView.swipeTopView(inDirection: .Left)
        delegate.didSwipeCard(self, direction: .Left)
        stopVideo()
    }
    
    @IBAction func didTouchLikeButton(_ sender: Any) {
        self.swipeableView.swipeTopView(inDirection: .Right)
        delegate.didSwipeCard(self, direction: .Right)
        stopVideo()
    }
    

    func setup() {
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
        
    }
}
