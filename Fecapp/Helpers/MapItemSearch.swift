//
//  MapItemSearch.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import MapKit

class MapItemSearch {
    static private let distanceThreshold: Double = 50.0

    static func search(shop: Shop) async -> MKMapItem {
        do {
            guard let mapItem = try await searchInAppleMaps(shop: shop) else {
                return createMapItem(from: shop)
            }

            return mapItem
        } catch {
            return createMapItem(from: shop)
        }
    }

    /// Looks for shop in Apple Maps' database, will double check if the venue
    /// is the one we're looking for (by comparing coordinates)
    static private func searchInAppleMaps(shop: Shop) async throws -> MKMapItem? {
        let region = MKCoordinateRegion(
            center: shop.coordinates.locationCoordinate,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = shop.title
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.cafe])
        request.region = region

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        let items = response.mapItems.filter { item in
            guard let location = item.placemark.location else {
                return false
            }

            return location.distance(from: shop.coordinates.location) < distanceThreshold
        }

        return items.first
    }

    /// Creats a custom MKMapItem with shop's information
    static private func createMapItem(from shop: Shop) -> MKMapItem {
        let addressDictionary = [
            "CNPostalAddressStreetKey": shop.address
        ]

        let placemark = MKPlacemark(
            coordinate: shop.coordinates.locationCoordinate,
            addressDictionary: addressDictionary
        )

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shop.title
        mapItem.url = shop.webURL
        mapItem.pointOfInterestCategory = .cafe

        return mapItem
    }
}
