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
import SDWebImage

enum ShopDetailViewModelEvent {
    case openInstagram(username: String)
    case openMap(shop: Shop)
    case openMenu(shop: Shop)
    case openRoaster(_ roaster: Roaster)
    case share(shop: Shop)
}

class ShopDetailViewModel {
    let shop: Shop
    let style: ViewControllerStyle
    let view: ShopDetailView

    let events: AnyPublisher<ShopDetailViewModelEvent, Never>
    private let _events = PassthroughSubject<ShopDetailViewModelEvent, Never>()

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
        guard let linkImage = UIImage(named: "instagram", in: Bundle.main, with: nil) else {
            return NSAttributedString(string: shop.instagram)
        }

        return NSAttributedString(string: shop.instagram, leadingImage: linkImage)
    }

    var attributedRoaster: NSAttributedString {
        NSAttributedString(leadingBold: "Tostador: ", string: shop.roaster?.title ?? "N/A")
    }

    var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: shop.coordinates.locationCoordinate,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )
    }

    var instagramAction: UIAction {
        UIAction { [weak self] _ in
            guard let username = self?.shop.instagram else {
                return
            }

            self?._events.send(.openInstagram(username: username))
        }
    }

    var shareAction: UIAction {
        UIAction { [weak self] _ in
            guard let shop = self?.shop else {
                return
            }

            self?._events.send(.share(shop: shop))
        }
    }

    var menuAction: UIAction {
        UIAction { [weak self] _ in
            guard let shop = self?.shop else {
                return
            }

            self?._events.send(.openMenu(shop: shop))
        }
    }

    var roasterAction: UIAction {
        UIAction { [weak self] _ in
            guard let roaster = self?.shop.roaster else {
                return
            }

            self?._events.send(.openRoaster(roaster))
        }
    }

    init(shop: Shop, view: ShopDetailView, style: ViewControllerStyle) {
        self.shop = shop
        self.style = style
        self.events = _events.eraseToAnyPublisher()
        self.view = view
        updateContent()
    }

    func updateContent() {
        // Map
        setupMap()

        // Thumbnail
        updateThumbnail()

        // Title
        view.headView.titleLabel.text = shop.title

        // Share button
        view.headView.shareButton.addAction(shareAction, for: .touchUpInside)

        // Address: setup text and action
        setupAddressLabel()

        // Instagram: setup text and action
        view.instagramButton.setAttributedTitle(attributedInstagram, for: .normal)
        view.instagramButton.addAction(instagramAction, for: .touchUpInside)

        // Roaster: setup text and action
        view.roasterButton.setAttributedTitle(attributedRoaster, for: .normal)
        view.roasterButton.addAction(roasterAction, for: .touchUpInside)

        // Menu button
        view.menuButton.addAction(menuAction, for: .touchUpInside)
    }

    private func setupAddressLabel() {
        view.addressLabel.attributedText = attributedAddress

        let gesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        view.addressLabel.addGestureRecognizer(gesture)
    }

    private func setupMap() {
        // Setup gesture
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        view.headView.mapView.addGestureRecognizer(gesture)

        // Setup looks
        switch style {
        case .fullscreen:
            view.headView.mapView.setRegion(mapRegion, animated: false)

            let pin = MKPointAnnotation() // map pin
            pin.coordinate = shop.coordinates.locationCoordinate
            pin.title = shop.title
            view.headView.mapView.addAnnotation(pin)

        case .sheet:
            view.headView.mapView.isHidden = true
        }
    }

    func updateThumbnail() {
        guard let url = shop.thumbnail?.small else {
            view.headView.thumbnailImageView.isHidden = true
            return
        }

        view.headView.thumbnailImageView.sd_setImage(with: url)
    }

    @objc func addressTapped() {
        _events.send(.openMap(shop: shop))
    }

    @objc func mapTapped() {
        _events.send(.openMap(shop: shop))
    }
}
