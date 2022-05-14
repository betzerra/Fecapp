//
//  MapView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import MapKit
import UIKit

private let centerButtonHorizontalMargin: CGFloat = 20

class MapView: UIView {
    let mapView: MKMapView = MKMapView()

    let centerButton: UIButton = {
        let image = UIImage(systemName: "location.fill")

        let button = RoundedButton(configuration: .filled())
        button.tintColor = .systemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        mapView.loadInto(containerView: self)
        mapView.showsUserLocation = true

        addSubview(centerButton)
        NSLayoutConstraint.activate([
            centerButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            centerButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -centerButtonHorizontalMargin)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
