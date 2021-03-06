//
//  UIFont+Styles.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

// MARK: bold + italic
extension UIFont {
    // From https://spin.atomicobject.com/2018/02/02/swift-scaled-font-bold-italic/
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) // size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

// MARK: Custom font with preferred styles
extension UIFont {
    static func font(name: String, forTextStyle style: UIFont.TextStyle) -> UIFont {
        guard let font = UIFont(name: name, size: UIFont.labelFontSize) else {
            return UIFont.preferredFont(forTextStyle: style)
        }

        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
