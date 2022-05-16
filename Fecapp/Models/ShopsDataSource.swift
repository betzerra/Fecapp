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

    enum SortType {
        case rank
        case location
    }

    let baseURL = URL(string: "https://www.tomafeca.com")!
    let pluma: Pluma

    let locationManager: LocationManager

    @Published var sort: SortType = .rank

    @Published var shops: [Shop]?
    @Published var filteredNeighborhoods =  Set<Neighborhood>()

    var cancellables = [AnyCancellable]()

    init(locationManager: LocationManager) {
        pluma = Pluma(baseURL: baseURL, decoder: nil)
        self.locationManager = locationManager

        bind()

        Task {
            do {
                try await fetchShops()
            } catch {
                LogService.logError(error)
            }
        }
    }

    func bind() {
        locationManager
            .$lastLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let shops = self?.shops else {
                    return
                }

                // Update distance from user on all shops so they
                // can be sorted later
                shops.forEach { $0.distanceFromUser = $0.distance(to: location) }

                if self?.sort == .location {
                    self?.sortByNearestLocation()
                }
            }
            .store(in: &cancellables)

        $sort
            .sink { [weak self] type in
                switch type {
                case .rank:
                    self?.sortByRank()

                case .location:
                    self?.sortByNearestLocation()
                }
            }
            .store(in: &cancellables)
    }

    func fetchShops() async throws {
        LogService.debug("Shop request started")
        shops = try await pluma.request(
            method: .GET,
            path: "shops.json",
            params: nil
        )

        LogService.debug("Shop request finished", metadata: shops?.logMetadata)
    }

    func reset() {
        filteredNeighborhoods.removeAll()
    }

    private func sortByNearestLocation() {
        shops = shops?.sorted(by: { lhs, rhs in
            guard
                let lhsDistance = lhs.distanceFromUser,
                let rhsDistance = rhs.distanceFromUser else {
                return false
            }

            return lhsDistance < rhsDistance
        })
    }

    private func sortByRank() {
        shops = shops?.sorted(by: { lhs, rhs in
            if lhs.rank == rhs.rank {
                return lhs.title < rhs.title
            }

            return lhs.rank > rhs.rank
        })
        shops = shops?.sorted(by: { $0.rank > $1.rank })
    }
}
