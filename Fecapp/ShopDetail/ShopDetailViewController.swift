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
    private let headView: ShopHeadView
    private let containerStackView: UIStackView

    private var cancellables = [AnyCancellable]()

    init(shop: Shop) {
        self.viewModel = ShopDetailViewModel(shop: shop)

        self.headView = ShopHeadView(viewModel: viewModel)
        self.containerStackView = UIStackView(arrangedSubviews: [headView])

        super.init(nibName: nil, bundle: nil)

        title = viewModel.title

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                switch events {
                case .openMap(let shop):
                    self?.openMap(shop: shop)

                case .openRoasters:
                    // TODO: Implement this
                    LogService.info("openRoasters")

                case .openInstagram(let username):
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
        view.backgroundColor = .systemBackground

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(containerStackView)
    }

    private func setupConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
