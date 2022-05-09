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

    func formattedDistance(from location: CLLocation) -> String {
        let distance = shop.distance(to: location)

        switch distance {
        case 0..<1000:
            return String(format: "%.0fm", distance)

        default:
            return String(format: "%.1fkm", (distance/1000))
        }
    }

    func attributedSubtitle(location: CLLocation?) -> NSAttributedString {
        let neighborhood = shop.neighborhood?.title ?? ""
        let subtitle = NSMutableAttributedString(string: neighborhood)

        if let location = location {
            subtitle.append(NSAttributedString(string: " "))

            let distanceString = NSAttributedString(
                string: formattedDistance(from: location),
                attributes: [.foregroundColor: UIColor.tertiaryLabel.cgColor]
            )

            subtitle.append(distanceString)
        }

        return subtitle
    }

    func secondarySubtitle(location: CLLocation?) -> String? {
        guard let location = location else {
            return nil
        }

        return formattedDistance(from: location)
    }
}
