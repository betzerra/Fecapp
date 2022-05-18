//
//  UIButton+Configurations.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import UIKit

extension UIButton.Configuration {
    static func standardFill() -> UIButton.Configuration {
        var configuration: UIButton.Configuration = .filled()
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 12,
            bottom: 12,
            trailing: 12
        )

        return configuration
    }
}
