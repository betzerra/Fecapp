//
//  ShopCoordinates.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import MapKit

struct ShopCoordinates {
    let latitude, longitude: Double
}

extension ShopCoordinates {
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
