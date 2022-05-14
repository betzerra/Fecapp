//
//  MapView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import MapKit
import UIKit

class MapView: UIView {
    let mapView: MKMapView = MKMapView()

    init() {
        super.init(frame: .zero)
        mapView.loadInto(containerView: self)
        mapView.showsUserLocation = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
