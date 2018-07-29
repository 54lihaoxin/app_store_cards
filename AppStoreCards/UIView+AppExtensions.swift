//
//  UIView+AppExtensions.swift
//  AppStoreCards
//
//  Created by Haoxin Li on 7/5/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult func activateLayoutAnchorsWithSuperView(insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("\(#function) super view not found")
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false // Note: layout goes wrong if this is not set to false
        let constraints = [topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                           leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
                           bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom),
                           trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right)]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
