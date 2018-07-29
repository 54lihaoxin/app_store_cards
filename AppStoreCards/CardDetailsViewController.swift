//
//  CardDetailsViewController.swift
//  AppStoreCards
//
//  Created by Li, Haoxin on 7/28/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    static let heightAsCard: CGFloat = 400
    
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
        dismissButton.alpha = forCardCell ? 0 : 1
        view.layer.cornerRadius = forCardCell ? CardCollectionViewCell.cornerRadius : 0
    }
}
