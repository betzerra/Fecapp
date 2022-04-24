//
//  Shop.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation

struct Shop: Decodable {
    let id: Int
    let slug: String

    let createdAt, updatedAt: Date

    let title: String

    let address: String
    let latitude: Float
    let longitude: Float

    let instagram: String
    let hasDelivery: Bool
}

extension Shop: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Shop: Equatable {
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        lhs.id == rhs.id
    }
}
