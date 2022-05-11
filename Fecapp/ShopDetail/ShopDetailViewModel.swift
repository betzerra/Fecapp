//
//  ShopDetailViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import Foundation
import MapKit
import UIKit

enum ShopDetailViewModelEvents {
    case openMap(shop: Shop)
    case openInstagram(username: String)
    case openRoasters
}

class ShopDetailViewModel {
    let shop: Shop
    let view: ShopDetailView

    let events: AnyPublisher<ShopDetailViewModelEvents, Never>
    private let _events = PassthroughSubject<ShopDetailViewModelEvents, Never>()

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

    var openMapAction: UIAction {
        UIAction { [weak self] _ in
            guard let shop = self?.shop else {
                return
            }

            self?._events.send(.openMap(shop: shop))
        }
    }

    var instagramAction: UIAction {
        UIAction { [weak self] _ in
            guard let username = self?.shop.instagram else {
                return
            }

            self?._events.send(.openInstagram(username: username))
        }
    }

    var roastersAction: UIAction {
        UIAction { [weak self] _ in
            self?._events.send(.openRoasters)
        }
    }

    init(shop: Shop, view: ShopDetailView) {
        self.shop = shop
        self.events = _events.eraseToAnyPublisher()
        self.view = view

        updateContent()
    }

    func updateContent() {
        view.headView.addressButton.setAttributedTitle(attributedAddress, for: .normal)
        view.headView.addressButton.addAction(openMapAction, for: .touchUpInside)

        view.headView.instagramButton.setAttributedTitle(attributedInstagram, for: .normal)
        view.headView.instagramButton.addAction(instagramAction, for: .touchUpInside)

        view.headView.roasterButton.setAttributedTitle(attributedRoaster, for: .normal)
        view.headView.roasterButton.addAction(roastersAction, for: .touchUpInside)

        view.headView.mapView.setRegion(mapRegion, animated: false)

        let pin = MKPointAnnotation() // map pin
        pin.coordinate = shop.coordinates.locationCoordinate
        view.headView.mapView.addAnnotation(pin)
    }
}
