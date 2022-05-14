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

    let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        return label
    }()

    let thumbnailImageView: RoundedImageView = {
        return RoundedImageView(frame: .zero)
    }()

    // UI Constants
    private let horizontalPadding: CGFloat = 24.0
    private let spacing: CGFloat = 16.0
    private let mapHeight: CGFloat = 150
    private let thumbnailSize: CGFloat = 60

    init() {
        detailSubView = UIView(frame: .zero)
        containerStackView = UIStackView(arrangedSubviews: [mapView, detailSubView])

        super.init(frame: .zero)

        addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        detailSubView.translatesAutoresizingMaskIntoConstraints = false

        let titleStackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        titleStackView.spacing = spacing
        titleStackView.alignment = .center
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        let detailStackView = UIStackView(arrangedSubviews: [titleStackView, addressButton, instagramButton])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.spacing = spacing
        detailStackView.axis = .vertical

        detailSubView.addSubview(detailStackView)

        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            detailStackView.leftAnchor.constraint(equalTo: detailSubView.leftAnchor, constant: horizontalPadding),
            detailStackView.topAnchor.constraint(equalTo: detailSubView.topAnchor, constant: spacing),
            detailStackView.rightAnchor.constraint(equalTo: detailSubView.rightAnchor, constant: -horizontalPadding),
            detailStackView.bottomAnchor.constraint(equalTo: detailSubView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: mapHeight),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailSize),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
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
