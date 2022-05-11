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
    // Subviews
    private let containerStackView: UIStackView
    private let detailSubView: UIView

    let addressButton: UIButton = {
        return ShopHeadView.detailButton()
    }()

    let instagramButton: UIButton = {
        return ShopHeadView.detailButton()
    }()

    let roasterButton: UIButton = {
        return ShopHeadView.detailButton()
    }()

    let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        return view
    }()

    // UI Constants
    private let horizontalPadding: CGFloat = 16.0
    private let spacing: CGFloat = 16.0
    private let mapHeight: CGFloat = 150

    init() {
        detailSubView = UIView(frame: .zero)
        containerStackView = UIStackView(arrangedSubviews: [mapView, detailSubView])

        super.init(frame: .zero)

        addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = spacing

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        detailSubView.translatesAutoresizingMaskIntoConstraints = false

        let detailStackView = UIStackView(arrangedSubviews: [addressButton, instagramButton, roasterButton])
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

    static func detailButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }
}
