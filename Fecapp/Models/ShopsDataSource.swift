//
//  ShopsDataSource.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation
import Combine
import CoreLocation
import Pluma
import UIKit

enum Section {
    case main
}

class ShopsDataSource {
    let baseURL = URL(string: "https://www.tomafeca.com")!
    let pluma: Pluma

    @Published var shops: [Shop]?
    @Published var filteredNeighborhoods =  Set<Neighborhood>()

    init() {
        pluma = Pluma(baseURL: baseURL, decoder: nil)

        Task {
            do {
                try await fetchShops()
            } catch {
                LogService.error(error.localizedDescription.toMessage)
            }
        }
    }

    func fetchShops() async throws {
        LogService.debug("Shop request started")
        shops = try await pluma.request(
            method: .GET,
            path: "shops.json",
            params: nil
        )

        if let shops = shops {
            LogService.debug(shops.toMessage(event: "Shop request finished"))
        } else {
            LogService.debug("Shop request finished")
        }
    }

    func reset() {
        filteredNeighborhoods.removeAll()
    }

    func sortByNearestLocation(_ location: CLLocation) {
        shops = shops?.sorted(by: {
            $0.distance(to: location) < $1.distance(to: location)
        })
    }
}
