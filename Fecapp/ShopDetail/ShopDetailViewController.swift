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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

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
        Task {
            let item = await MapItemSearch.search(shop: shop)

            let region = MKCoordinateRegion(
                center: shop.coordinates.locationCoordinate,
                latitudinalMeters: 300,
                longitudinalMeters: 300
            )

            openMapItem(item, in: region)
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
