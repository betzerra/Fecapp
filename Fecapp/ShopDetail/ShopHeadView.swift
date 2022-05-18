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

    let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isZoomEnabled = false
        view.isPitchEnabled = false
        view.isRotateEnabled = false
        view.isScrollEnabled = false
        return view
    }()

    let shareButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let image = UIImage(systemName: "square.and.arrow.up.circle.fill")?
            .applyingSymbolConfiguration(symbolConfiguration)

        let button = UIButton(configuration: .plain())
        button.setImage(image, for: .normal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let thumbnailImageView: RoundedImageView = {
        return RoundedImageView(frame: .zero)
    }()

    // UI Constants
    private let mapHeight: CGFloat = 350
    private let thumbnailSize: CGFloat = 60
    private let stackViewTopMargin: CGFloat = 16
    private let horizontalSpacing: CGFloat = 16

    init() {
        let titleStackView = UIStackView(
            arrangedSubviews: [thumbnailImageView, titleLabel, shareButton]
        )
        titleStackView.spacing = horizontalSpacing
        titleStackView.alignment = .center
        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = UIEdgeInsets(
            top: stackViewTopMargin,
            left: horizontalSpacing,
            bottom: 0,
            right: horizontalSpacing
        )
        containerStackView = UIStackView(arrangedSubviews: [mapView, titleStackView])

        super.init(frame: .zero)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalCentering
        containerStackView.isLayoutMarginsRelativeArrangement = true

        addSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(containerStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: mapHeight),
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailSize),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
}
