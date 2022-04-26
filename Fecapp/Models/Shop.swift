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

    let thumbnail: ShopThumbnail?

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case createdAt
        case updatedAt
        case title
        case address
        case latitude
        case longitude
        case instagram
        case hasDelivery
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        slug = try values.decode(String.self, forKey: .slug)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
        title = try values.decode(String.self, forKey: .title)
        address = try values.decode(String.self, forKey: .address)
        latitude = try values.decode(Float.self, forKey: .latitude)
        longitude = try values.decode(Float.self, forKey: .longitude)
        instagram = try values.decode(String.self, forKey: .instagram)
        hasDelivery = try values.decode(Bool.self, forKey: .hasDelivery)
        thumbnail = try? values.decode(ShopThumbnail.self, forKey: .thumbnail)
    }
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
