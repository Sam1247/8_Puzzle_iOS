//
//  NumberCell.swift
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

import UIKit


class NumberCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 12
            containerView.backgroundColor = .systemPink
        }
    }

    @IBOutlet var numberLabel: UILabel!
}
