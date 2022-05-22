//
//  UIColor+Utils.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

extension UIColor {
    static var accent: UIColor {
        return UIColor(named: "AccentColor") ?? .systemBlue
    }

    static var buttonTitle: UIColor {
        return UIColor(named: "ButtonTitleColor") ?? .white
    }
}
