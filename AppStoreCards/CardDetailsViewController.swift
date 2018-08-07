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
    
    private static let placeHolderContentHeight: CGFloat = 400 // TODO: use `NSString.boundingRect(...)` to compute the height later
    
    @IBOutlet private weak var cardPreviewContainer: UIView!
    @IBOutlet private weak var cardPreviewContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cardPreviewContainerHeightConstraint: NSLayoutConstraint! {
        didSet {
            cardPreviewContainerHeightConstraint.constant = CardDetailsViewController.heightAsCard
        }
    }
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            imageViewHeightConstraint.constant = CardDetailsViewController.fullScreenPreviewContainerHeight
        }
    }
    @IBOutlet private weak var contentScrollView: UIScrollView!
    @IBOutlet private weak var dismissButton: UIButton!
    
    private var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 800))
        textView.isScrollEnabled = false
        textView.text = String(repeating: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", count: 20)
        return textView
    }()
    private lazy var textViewWidthConstraint = textView.widthAnchor.constraint(equalToConstant: view.bounds.size.width)
    private lazy var textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: CardDetailsViewController.fullScreenPreviewContainerHeight + CardDetailsViewController.placeHolderContentHeight)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: CardDetailsViewController.className, bundle: nil)
    }
}

// MARK: - API

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

// MARK: - Override

extension CardDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never // otherwise the status bar height will become top inset
        }
        setUpContentView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if textViewWidthConstraint.constant != view.bounds.size.width {
            textViewWidthConstraint.constant = view.bounds.size.width
        }
    }
}

// MARK: - IBAction

extension CardDetailsViewController {
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension CardDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cardPreviewContainerTopConstraint.constant = scrollView.contentOffset.y
        cardPreviewContainer.updateConstraintsIfNeeded()
    }
}

// MARK: - Private helpers

private extension CardDetailsViewController {
    
    func setUpContentView() {
        contentScrollView.addSubview(textView)
        textView.activateLayoutAnchorsWithSuperView(insets: UIEdgeInsets(top: CardDetailsViewController.fullScreenPreviewContainerHeight, left: 0, bottom: 0, right: 0))
        textViewWidthConstraint.isActive = true
        textViewHeightConstraint.isActive = true
        contentScrollView.scrollIndicatorInsets = UIEdgeInsets(top: CardDetailsViewController.fullScreenPreviewContainerHeight, left: 0, bottom: 0, right: 0)
    }
}
