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

    enum Style {
        case fullscreen
        case sheet
    }

    let viewModel: ShopDetailViewModel

    // Subviews
    private let _view = ShopDetailView()

    private var cancellables = [AnyCancellable]()

    init(shop: Shop, style: Style) {
        self.viewModel = ShopDetailViewModel(shop: shop, view: _view, style: style)

        super.init(nibName: nil, bundle: nil)

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                switch events {
                case .openMap(let shop):
                    LogService.info("Opened map: \(shop.title)")
                    self?.openMap(shop: shop)

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

        search(shop: shop, in: region) { [weak self] response, error in
            guard let self = self else {
                return
            }

            if let error = error {
                LogService.logError(error)
            }

            guard let response = response, let item = response.mapItems.first else {
                let customMapItem = self.mapItem(from: shop)
                self.openMapItem(customMapItem, in: region)
                return
            }

            self.openMapItem(item, in: region)
        }
    }

    private func openMapItem(_ mapItem: MKMapItem, in region: MKCoordinateRegion) {
        let mapItemName = mapItem.name ?? "N/A"
        LogService.debug("Opening mapItem: \(mapItemName)")

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span),
        ]

        mapItem.openInMaps(launchOptions: options)
    }

    private func search(
        shop: Shop,
        in region: MKCoordinateRegion,
        completion: @escaping ((MKLocalSearch.Response?, Error?) -> ())
    ) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = shop.title
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.cafe, .restaurant])
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completion)
    }

    private func mapItem(from shop: Shop) -> MKMapItem {
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

        return mapItem
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
