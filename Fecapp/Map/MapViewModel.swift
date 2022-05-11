//
//  MapViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import Combine
import MapKit

class MapViewModel {
    let dataSource: ShopsDataSource
    let view: MapView
    private var cancellables = [AnyCancellable]()

    init(dataSource: ShopsDataSource, view: MapView) {
        self.dataSource = dataSource
        self.view = view

        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { shops in
                // Remove all annotations before adding them back
                view.mapView.removeAnnotations(view.mapView.annotations)

                shops.forEach { shop in
                    let pin = MKPointAnnotation() // map pin
                    pin.coordinate = shop.coordinates.locationCoordinate
                    view.mapView.addAnnotation(pin)
                }

                // Center map and zoom out to fit all the pins
                view.mapView.showAnnotations(view.mapView.annotations, animated: true)
            }
            .store(in: &cancellables)
    }
}
