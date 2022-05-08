//
//  ShopsDataSource.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation
import Combine
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
                print(error.localizedDescription)
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
}
