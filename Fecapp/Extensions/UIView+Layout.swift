//
//  UIView+Layout.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import UIKit

extension UIView {
    /// Adds a *subview* inside a *containerView* with a given *inset* and *priority*
    func loadInto(containerView: UIView, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            topAnchor.constraint(equalTo: containerView.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: insets.left)
        ]

        constraints.forEach { $0.priority = priority }
        NSLayoutConstraint.activate(constraints)
    }
}
