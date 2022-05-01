//
//  ShopDetailViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import MapKit
import UIKit

class ShopDetailViewModel {
    let shop: Shop

    var title: String {
        shop.title
    }

    var attributedAddress: NSAttributedString {
        guard let pinImage = UIImage(systemName: "mappin.circle") else {
            return NSAttributedString(string: shop.address)
        }

        let attachment = NSTextAttachment(image: pinImage)
        let string = NSMutableAttributedString(attachment: attachment)
        string.append(NSAttributedString(string: " \(shop.address)"))

        if let neighborhood = shop.neighborhood {
            string.append(NSAttributedString(string: ", \(neighborhood.title)"))
        }

        return string
    }

    var attributedInstagram: NSAttributedString {
        guard let linkImage = UIImage(systemName: "link") else {
            return NSAttributedString(string: shop.instagram)
        }

        let attachment = NSTextAttachment(image: linkImage)
        let string = NSMutableAttributedString(attachment: attachment)
        string.append(NSAttributedString(string: " \(shop.instagram)"))

        return string
    }

    var attributedRoaster: NSAttributedString {
        let roasterString = "Tostador: "
        let string = NSMutableAttributedString(string: roasterString)
        string.addAttribute(
            .font, value: UIFont.preferredFont(forTextStyle: .body).bold(),
            range: NSRange.init(location: 0, length: roasterString.utf16.count)
        )

        string.append(NSAttributedString(string: "N/A"))
        return string
    }

    var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: shop.coordinates.locationCoordinate,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )
    }

    init(shop: Shop) {
        self.shop = shop
    }
}
