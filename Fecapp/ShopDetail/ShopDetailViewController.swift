//
//  ShopDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import Foundation
import MapKit
import UIKit

class ShopDetailViewController: UIViewController {
    let viewModel: ShopDetailViewModel

    // Subviews
    private let _view = ShopDetailView()
    
    private var cancellables = [AnyCancellable]()

    init(shop: Shop) {
        self.viewModel = ShopDetailViewModel(shop: shop, view: _view)

        super.init(nibName: nil, bundle: nil)

        title = viewModel.title

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                switch events {
                case .openMap(let shop):
                    LogService.info("Opened map: \(shop.title)")
                    self?.openMap(shop: shop)

                case .openRoasters:
                    // TODO: Implement this
                    LogService.info("openRoasters")

                case .openInstagram(let username):
                    LogService.info("Opened instagram: \(username)")
                    self?.openInstagram(username: username)
                }
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }

    private func openMap(shop: Shop) {
        let region = MKCoordinateRegion(
            center: shop.coordinates.locationCoordinate,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )

        let addressDictionary = [
            "CNPostalAddressStreetKey": shop.address
        ]

        let placemark = MKPlacemark(
            coordinate: shop.coordinates.locationCoordinate,
            addressDictionary: addressDictionary
        )

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shop.title
        mapItem.url = shop.webURL
        mapItem.pointOfInterestCategory = .cafe

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span),
        ]

        mapItem.openInMaps(launchOptions: options)
    }

    private func openInstagram(username: String) {
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
    }
}
