//
//  MapViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import Combine
import MapKit

enum MapViewModelEvent {
    case selected(shop: Shop)
}

class MapViewModel: NSObject, MKMapViewDelegate {
    private var cancellables = [AnyCancellable]()
    private let _events = PassthroughSubject<MapViewModelEvent, Never>()
    let events: AnyPublisher<MapViewModelEvent, Never>

    init(dataSource: ShopsDataSource, view: MapView) {
        events = _events.eraseToAnyPublisher()

        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { shops in
                // Remove all annotations before adding them back
                view.mapView.removeAnnotations(view.mapView.annotations)

                shops.forEach { shop in
                    let pin = ShopMapAnnotation(shop: shop) // map pin
                    view.mapView.addAnnotation(pin)
                }

                // Center map and zoom out to fit all the pins
                view.mapView.showAnnotations(view.mapView.annotations, animated: true)
            }
            .store(in: &cancellables)

        super.init()
        view.mapView.delegate = self
    }

    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ShopMapAnnotation else {
            return
        }

        LogService.info("Annotation selected: \(annotation.shop.title)")
        _events.send(.selected(shop: annotation.shop))
    }
}
