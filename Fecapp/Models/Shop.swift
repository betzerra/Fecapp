//
//  Shop.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import CoreLocation
import Foundation

class Shop: Decodable {
    let id: Int
    let slug: String

    let createdAt, updatedAt: Date

    let title: String

    let address: String
    let coordinates: ShopCoordinates
    var distanceFromUser: CLLocationDistance?
    let neighborhood: Neighborhood?

    let instagram: String
    let hasDelivery: Bool
    let rank: Int

    let message: String?

    let thumbnail: ShopThumbnail?

    var webURL: URL? {
        URL(string: "https://www.tomafeca.com/d/\(slug)")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case createdAt
        case updatedAt
        case title
        case address
        case latitude
        case longitude
        case neighborhood
        case instagram
        case hasDelivery
        case rank
        case message
        case thumbnail
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        slug = try values.decode(String.self, forKey: .slug)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
        title = try values.decode(String.self, forKey: .title)
        address = try values.decode(String.self, forKey: .address)

        coordinates = ShopCoordinates(
            latitude: try values.decode(Double.self, forKey: .latitude),
            longitude: try values.decode(Double.self, forKey: .longitude)
        )

        neighborhood = try? values.decode(Neighborhood.self, forKey: .neighborhood)
        instagram = try values.decode(String.self, forKey: .instagram)
        hasDelivery = try values.decode(Bool.self, forKey: .hasDelivery)
        rank = (try? values.decode(Int.self, forKey: .rank)) ?? 0

        let shopMessage = try? values.decodeIfPresent(String.self, forKey: .message)
        message = (shopMessage != "") ? shopMessage : nil
        thumbnail = try? values.decode(ShopThumbnail.self, forKey: .thumbnail)
    }

    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.coordinates.location)
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
