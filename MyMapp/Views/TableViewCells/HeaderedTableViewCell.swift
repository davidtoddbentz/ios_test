//
//  HeaderedTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 05/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import Foundation

protocol HeaderedTableViewCell {
    weak var header: UIView! {get set}
    weak var background: UIView! {get set}
}
