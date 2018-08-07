//
//  CardAnimationController.swift
//  AppStoreCards
//
//  Created by Li, Haoxin on 7/28/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

protocol CardAnimationControllerDelegate: class {
    func presentAnimationEnded(_ transitionCompleted: Bool)
    func dismissAnimationEnded(_ transitionCompleted: Bool)
}

class CardAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Mode {
        case present
        case dismiss
    }
    
    fileprivate let duration: TimeInterval = 0.5
    fileprivate let damping: CGFloat = 1
    fileprivate let initialSpringVelocity: CGFloat = 5
    
    fileprivate let mode: Mode
    fileprivate let card: CardCollectionViewCell
    fileprivate let originalFrame: CGRect // TODO: This will be need to be obtained from delegate to handle view resizing and rotation.
    private unowned let delegate: CardAnimationControllerDelegate
    
    init(mode: Mode, card: CardCollectionViewCell, originalFrame: CGRect, longLifeDelegate: CardAnimationControllerDelegate) {
        self.mode = mode
        self.card = card
        self.originalFrame = originalFrame
        delegate = longLifeDelegate
    }
    
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch mode {
        case .present:
            presentTransition(using: transitionContext)
        case .dismiss:
            dismissTransition(using: transitionContext)
        }
    }
    
    /// A conforming object implements this method if the transition it creates can
    /// be interrupted. For example, it could return an instance of a
    /// UIViewPropertyAnimator. It is expected that this method will return the same
    /// instance for the life of a transition.
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//
//    }
    
    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    func animationEnded(_ transitionCompleted: Bool) {
        switch mode {
        case .present:
            delegate.presentAnimationEnded(transitionCompleted)
        case .dismiss:
            delegate.dismissAnimationEnded(transitionCompleted)
        }
    }
}

private extension CardAnimationController {
    
    func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentingViewController = transitionContext.viewController(forKey: .from) else {
            assertionFailure("\(#function) presentingViewController is nil")
            return
        }
        guard let cardDetailsViewController = transitionContext.viewController(forKey: .to) as? CardDetailsViewController else {
            assertionFailure("\(#function) cardDetailsViewController is nil")
            return
        }
        
        // Do not call `layoutIfNeeded` or add constraint before calling `UIView.animate`, otherwise the animation will be messed up.
        let container = transitionContext.containerView
        container.addSubview(presentingViewController.view) // Note: If the presenting is not added to container, the background will be messed up.
        container.addSubview(cardDetailsViewController.view)
        cardDetailsViewController.view.frame = originalFrame
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: [],
                       animations: { () -> Void in
            cardDetailsViewController.configure(forCardCell: false)
            cardDetailsViewController.view.frame = transitionContext.finalFrame(for: cardDetailsViewController)
            cardDetailsViewController.view.activateLayoutAnchorsWithSuperView() // Set up constraints only after setting up the final frame correctly.
            cardDetailsViewController.view.layoutIfNeeded() // Only call `layoutIfNeeded` for the final step.
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled) // Do not forget this.
        }
    }
    
    func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let cardDetailsViewController = transitionContext.viewController(forKey: .from) as? CardDetailsViewController else {
            assertionFailure("\(#function) cardDetailsViewController is nil")
            return
        }
        guard let presentingViewController = transitionContext.viewController(forKey: .to) else {
            assertionFailure("\(#function) presentingViewController is nil")
            return
        }
        
        let container = transitionContext.containerView
        container.removeConstraints(container.constraints) // Remove old constraints, otherwise constraint conflicts will mess up the animation.
        container.backgroundColor = .red // This color is for debugging - you should not see it if things are working fine
        container.addSubview(presentingViewController.view) // If the presenting is not added to container, the background will be messed up.
        container.addSubview(cardDetailsViewController.view)
        
        // Animate the card while it's still in the container. Move the card view controller back to the card cell only after animation completes.
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: [],
                       animations: { () -> Void in
            cardDetailsViewController.configure(forCardCell: true)
            cardDetailsViewController.view.frame = self.originalFrame
            cardDetailsViewController.view.activateLayoutAnchorsWithSuperView(insets: self.originalFrame.insets(forContainerSize: container.bounds.size))
            cardDetailsViewController.view.layoutIfNeeded()
        }) { (finished) -> Void in
            // Add `cardDetailsViewController` back to the card cell. Do not call `transitionContext.completeTransition`
            // after `card.configure`, otherwise the cell will lose `cardDetailsViewController` and becomes empty.
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.card.configure(withViewController: cardDetailsViewController)
        }
    }
}

private extension CGRect {
    
    func insets(forContainerSize size: CGSize) -> UIEdgeInsets {
        return UIEdgeInsets(top: minY, left: minX, bottom: size.height - maxY, right: size.width - maxX)
    }
}
