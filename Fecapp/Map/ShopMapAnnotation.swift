//
//  ShopMapAnnotation.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import MapKit

class ShopMapAnnotation: NSObject, MKAnnotation {
    let shop: Shop
    var coordinate: CLLocationCoordinate2D

    var title: String? {
        shop.title
    }

    init(shop: Shop) {
        coordinate = shop.coordinates.locationCoordinate
        self.shop = shop
        super.init()
    }
}
