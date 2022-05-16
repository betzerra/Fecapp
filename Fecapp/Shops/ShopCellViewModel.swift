//
//  ShopCellViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 26/04/2022.
//

import Foundation
import UIKit
import CoreLocation

struct ShopCellViewModel {
    let shop: Shop

    var title: String {
        shop.title
    }

    private func formattedDistance(_ distance: CLLocationDistance) -> String {
        switch distance {
        case 0..<1000:
            return String(format: "%.0fm", distance)

        default:
            return String(format: "%.1fkm", (distance/1000))
        }
    }

    var attributedSubtitle: NSAttributedString {
        let neighborhood = shop.neighborhood?.title ?? ""
        let subtitle = NSMutableAttributedString(string: neighborhood)

        if let distance = shop.distanceFromUser {
            subtitle.append(NSAttributedString(string: " "))

            let distanceString = NSAttributedString(
                string: formattedDistance(distance),
                attributes: [.foregroundColor: UIColor.tertiaryLabel.cgColor]
            )

            subtitle.append(distanceString)
        }

        return subtitle
    }
}
