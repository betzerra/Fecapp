//
//  UIButton+Styles.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

extension UIButton {
    static func detailButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }
}
