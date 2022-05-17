//
//  MapView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import MapKit
import UIKit

private let buttonsStackViewPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
private let buttonsStackViewCornerRadius: CGFloat = 8.0
private let buttonsStackViewSpacing: CGFloat = 16.0
private let centerButtonHorizontalMargin: CGFloat = 16.0

class MapView: UIView {
    let mapView: MKMapView = MKMapView()

    let centerButton: UIButton = {
        let image = UIImage(systemName: "location.fill")
        let button = UIButton(type: .system)
        button.tintColor = .tertiaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()

    let showAllButton: UIButton = {
        let image = UIImage(systemName: "minus.magnifyingglass")
        let button = UIButton(type: .system)
        button.tintColor = .tertiaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)

        let stackView = UIStackView(arrangedSubviews: [centerButton, showAllButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
        stackView.layoutMargins = buttonsStackViewPadding
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = buttonsStackViewCornerRadius
        stackView.spacing = buttonsStackViewSpacing

        mapView.loadInto(containerView: self)
        mapView.showsUserLocation = true
        mapView.showsCompass = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -centerButtonHorizontalMargin)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
