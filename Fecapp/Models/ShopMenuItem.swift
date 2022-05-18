//
//  ShopMenuItem.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation

struct ShopMenuItem: Decodable {
    let id: Int
    let title: String
    let price: Double?

    var priceString: String {
        guard let price = price else {
            return "-"
        }

        return String(format: "$%.0f", price)
    }
}

extension ShopMenuItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ShopMenuItem: Equatable {
    static func == (lhs: ShopMenuItem, rhs: ShopMenuItem) -> Bool {
        lhs.id == rhs.id
    }
}
