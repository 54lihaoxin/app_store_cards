//
//  CardsViewController.swift
//  AppStoreCards
//
//  Created by Haoxin Li on 7/5/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.dataSource = self
        cv.delegate = self
        cv.register(UINib(nibName: CardCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        cv.backgroundColor = .orange
        return cv
    }()
    
    fileprivate let presentableViewControllers: [CardDetailsViewController] = {
        var viewControllers: [CardDetailsViewController] = []
        for i in 0..<20 {
            let vc = CardDetailsViewController()
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    fileprivate weak var selectedCard: CardCollectionViewCell?
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
