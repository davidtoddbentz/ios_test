//
//  SocialLoginCollectionViewCell.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 25/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import UIKit

class SocialLoginCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
  
  
  var viewModel: SocialLoginViewCellModel? {
    didSet {
      guard let viewModel = self.viewModel else { return }
      
      self.imageView.image = viewModel.image ?? UIImage(named: "placeholder")
      
      self.titleLabel.text = viewModel.title
      self.descriptionLabel.text = viewModel.description
      
      let currentSize = self.descriptionLabel.bounds.size
      let newSize = self.descriptionLabel.sizeThatFits(currentSize)
      self.labelHeightConstraint.constant = newSize.height
    }
  }
}
