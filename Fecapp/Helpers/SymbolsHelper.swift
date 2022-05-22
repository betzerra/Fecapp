//
//  SymbolsHelper.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

class SymbolsHelper {
    static func defaultConfiguration(pointSize: CGFloat) -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
            .applying(UIImage.SymbolConfiguration(hierarchicalColor: .accent))
    }

    static func image(named name: String) -> UIImage? {
        // Will try to get a symbol from the OS
        guard let image = UIImage(systemName: name, withConfiguration: nil) else {
            // if it's not found, then try to look for a custom symbol saved in Assets.xcassets
            return UIImage(named: name, in: Bundle.main, with: nil)
        }

        return image
    }
}
