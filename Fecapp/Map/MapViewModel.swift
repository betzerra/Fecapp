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
    private let view: MapView

    private var cancellables = [AnyCancellable]()
    private let _events = PassthroughSubject<MapViewModelEvent, Never>()
    let events: AnyPublisher<MapViewModelEvent, Never>

    init(dataSource: ShopsDataSource, view: MapView) {
        events = _events.eraseToAnyPublisher()

        self.view = view
        super.init()

        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] shops in
                // Remove all annotations before adding them back
                view.mapView.removeAnnotations(view.mapView.annotations)

                shops.forEach { shop in
                    let pin = ShopMapAnnotation(shop: shop) // map pin
                    view.mapView.addAnnotation(pin)
                }

                self?.showAllAnnotations()
            }
            .store(in: &cancellables)

        view.mapView.delegate = self

        // When the centerButton is pressed, it centers the map
        // on the user's location
        view.centerButton.addTarget(
            self,
            action: #selector(centerButtonPressed(_:)),
            for: .touchUpInside
        )

        // When the showAllButton is pressed, it zooms out to fit all the
        // coffee pins
        view.showAllButton.addTarget(
            self,
            action: #selector(showAllButtonPressed(_:)),
            for: .touchUpInside
        )
    }

    /// Center map and zoom out to fit all the pins
    private func showAllAnnotations() {
        view.mapView.showAnnotations(view.mapView.annotations, animated: true)
    }

    // MARK: - Actions
    @objc private func centerButtonPressed(_ sender: Any) {
        LogService.info("Center Button pressed")
        view.mapView.setCenter(view.mapView.userLocation.coordinate, animated: true)
    }

    @objc private func showAllButtonPressed(_ sender: Any) {
        LogService.info("Show All Button pressed")
        showAllAnnotations()
    }

    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ShopMapAnnotation else {
            return
        }

        LogService.info("Annotation selected: \(annotation.shop.title)")

        // Horrible hack to put the annotation a little bit above of the
        // shop detail card
        annotation.coordinate.latitude -= 0.0015

        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 600,
            longitudinalMeters: 600
        )
        mapView.setRegion(region, animated: true)

        _events.send(.selected(shop: annotation.shop))
    }
}
