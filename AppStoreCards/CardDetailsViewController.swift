//
//  CardDetailsViewController.swift
//  AppStoreCards
//
//  Created by Li, Haoxin on 7/28/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    static let heightAsCard: CGFloat = 350
    static let fullScreenPreviewContainerHeight = heightAsCard + 50
    
    @IBOutlet weak var cardPreviewContainer: UIView!
    @IBOutlet weak var cardPreviewContainerHeightConstraint: NSLayoutConstraint! {
        didSet {
            cardPreviewContainerHeightConstraint.constant = CardDetailsViewController.heightAsCard
        }
    }
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            imageViewHeightConstraint.constant = CardDetailsViewController.fullScreenPreviewContainerHeight
        }
    }
    @IBOutlet private weak var dismissButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: CardDetailsViewController.className, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CardDetailsViewController {
    
    func configure(forCardCell: Bool) {
        if forCardCell {
            dismissButton.alpha = 0
            view.layer.cornerRadius = CardCollectionViewCell.cornerRadius
            cardPreviewContainerHeightConstraint.constant = CardDetailsViewController.heightAsCard
        } else {
            dismissButton.alpha = 1
            view.layer.cornerRadius = 0
            cardPreviewContainerHeightConstraint.constant = CardDetailsViewController.fullScreenPreviewContainerHeight
        }
    }
}
