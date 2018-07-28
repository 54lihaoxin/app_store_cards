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
    
    private var presentableViewController: CardDetailsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(withViewController viewController: CardDetailsViewController) {
        guard presentableViewController != viewController else {
            return
        }
        if let presentedViewController = presentableViewController {
            presentedViewController.view.removeFromSuperview()
        }
        presentableViewController = viewController
        viewController.loadViewIfNeeded()
        addSubview(viewController.view)
        viewController.view.activateLayoutAnchorsWithSuperView()
        viewController.configure(forCardCell: true)
    }
}
