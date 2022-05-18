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

    var allShops: [Shop]?
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

    private func bind() {
        locationManager
            .$lastLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self, let shops = self.shops else {
                    return
                }

                self.shops = self.process(shops: shops, sort: self.sort)
            }
            .store(in: &cancellables)

        $sort
            .sink { [weak self] sort in
                guard let shops = self?.shops else {
                    return
                }

                self?.shops = self?.process(shops: shops, sort: sort)
            }
            .store(in: &cancellables)
    }

    func fetchShops() async throws {
        LogService.debug("Shop list request started")

        guard let shopsFromServer: [Shop] = try await pluma.request(
            method: .GET,
            path: "shops.json",
            params: nil
        ) else {
            LogService.warning("Didn't get any shops after request")
            return
        }

        shops = process(shops: shopsFromServer, sort: sort)
        allShops = shops

        LogService.debug("Shop list request finished", metadata: shops?.logMetadata)
    }

    func fetchShopDetail(slug: String) async throws -> ShopDetail? {
        LogService.debug("Shop '\(slug)' request started")

        guard let shop: ShopDetail = try await pluma.request(
            method: .GET,
            path: "/d/\(slug).json",
            params: nil
        ) else {
            return nil
        }

        LogService.debug("Shop '\(slug)' request finished")
        return shop
    }

    func search(with target: String?) {
        guard let target = target, target != "" else {
            shops = allShops
            return
        }

        shops = allShops?.filter { $0.title.contains(target) }
    }

    private func process(shops: [Shop], sort: SortType) -> [Shop] {
        // Update distance from user on all shops so they
        // can be sorted later
        if let location = locationManager.lastLocation {
            shops.forEach { $0.distanceFromUser = $0.distance(to: location) }

            if sort == .location {
                return sortByNearestLocation(shops)
            }
        }

        if sort == .rank {
            return sortByRank(shops)
        }

        return shops
    }

    private func sortByNearestLocation(_ shops: [Shop]) -> [Shop] {
        return shops.sorted(by: { lhs, rhs in
            guard
                let lhsDistance = lhs.distanceFromUser,
                let rhsDistance = rhs.distanceFromUser else {
                return false
            }

            return lhsDistance < rhsDistance
        })
    }

    private func sortByRank(_ shops: [Shop]) -> [Shop] {
        return shops.sorted(by: { lhs, rhs in
            if lhs.rank == rhs.rank {
                return lhs.title < rhs.title
            }

            return lhs.rank > rhs.rank
        })
    }
}
