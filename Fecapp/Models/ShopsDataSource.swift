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
                LogService.info("Shop request started")
                try await fetchShops()
                LogService.info("Shop request finished")
            } catch {
                LogService.error(error.localizedDescription.toMessage)
            }
        }
    }

    func fetchShops() async throws {
        shops = try await pluma.request(
            method: .GET,
            path: "shops.json",
            params: nil
        )
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
