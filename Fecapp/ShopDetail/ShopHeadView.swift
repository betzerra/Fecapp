//
//  ShopHeadView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import MapKit
import UIKit

class ShopHeadView: UIView {
    let viewModel: ShopDetailViewModel

    // Subviews
    private let containerStackView: UIStackView
    private let detailSubView: UIView

    private let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let instagramLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let roasterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        return view
    }()

    // UI Constants
    private let horizontalPadding: CGFloat = 16.0
    private let spacing: CGFloat = 16.0
    private let mapHeight: CGFloat = 150

    init(viewModel: ShopDetailViewModel) {
        self.viewModel = viewModel

        detailSubView = UIView(frame: .zero)
        containerStackView = UIStackView(arrangedSubviews: [mapView, detailSubView])

        super.init(frame: .zero)

        addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = spacing

        setupLayout()
        updateContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        detailSubView.translatesAutoresizingMaskIntoConstraints = false

        let detailStackView = UIStackView(arrangedSubviews: [addressLabel, instagramLabel, roasterLabel])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.spacing = spacing
        detailStackView.axis = .vertical

        detailSubView.addSubview(detailStackView)

        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            detailStackView.leftAnchor.constraint(equalTo: detailSubView.leftAnchor, constant: horizontalPadding),
            detailStackView.topAnchor.constraint(equalTo: detailSubView.topAnchor),
            detailStackView.rightAnchor.constraint(equalTo: detailSubView.rightAnchor, constant: -horizontalPadding),
            detailStackView.bottomAnchor.constraint(equalTo: detailSubView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: mapHeight)
        ])
    }

    private func updateContent() {
        addressLabel.attributedText = viewModel.attributedAddress
        instagramLabel.attributedText = viewModel.attributedInstagram
        roasterLabel.attributedText = viewModel.attributedRoaster

        mapView.setRegion(viewModel.mapRegion, animated: false)

        let pin = MKPointAnnotation() // map pin
        pin.coordinate = viewModel.shop.coordinates.locationCoordinate
        mapView.addAnnotation(pin)
    }
}
