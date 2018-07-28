//
//  CardCollectionViewCell.swift
//  AppStoreCards
//
//  Created by Haoxin Li on 7/5/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
