//
//  CardsViewController.swift
//  AppStoreCards
//
//  Created by Haoxin Li on 7/5/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.dataSource = self
        cv.delegate = self
        cv.register(UINib(nibName: CardCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        cv.backgroundColor = .orange
        return cv
    }()
    
    private lazy var presentableViewControllers: [CardDetailsViewController] = {
        var viewControllers: [CardDetailsViewController] = []
        for i in 0..<20 {
            let vc = CardDetailsViewController()
            vc.transitioningDelegate = self
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    private weak var selectedCard: CardCollectionViewCell?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        collectionView.activateLayoutAnchorsWithSuperView()
    }
}

// MARK: - UICollectionViewDataSource

extension CardsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentableViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension CardsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CardCollectionViewCell else {
            fatalError()
        }
        cell.configure(withViewController: presentableViewControllers[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {
            assertionFailure()
            return
        }
        selectedCard = cell
        present(presentableViewControllers[indexPath.row], animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CardsViewController: UICollectionViewDelegateFlowLayout {
    
    private var padding: CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - padding * 2, height: CardDetailsViewController.heightAsCard)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CardsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedCard = selectedCard else {
            assertionFailure()
            return nil
        }
        return CardAnimationController(mode: .present,
                                       card: selectedCard,
                                       originalFrame: view.convert(selectedCard.frame, from: collectionView),
                                       longLifeDelegate: self)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedCard = selectedCard else {
            assertionFailure()
            return nil
        }
        return CardAnimationController(mode: .dismiss,
                                       card: selectedCard,
                                       originalFrame: view.convert(selectedCard.frame, from: collectionView),
                                       longLifeDelegate: self)
    }
}

// MARK: - CardAnimationControllerDelegate

extension CardsViewController: CardAnimationControllerDelegate {
    
    func presentAnimationEnded(_ transitionCompleted: Bool) {
        print("\(#function) transitionCompleted:", transitionCompleted)
    }
    
    func dismissAnimationEnded(_ transitionCompleted: Bool) {
        print("\(#function) transitionCompleted:", transitionCompleted)
    }
}
