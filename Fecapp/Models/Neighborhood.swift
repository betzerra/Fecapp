//
//  Neighborhood.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 26/04/2022.
//

import Foundation

struct Neighborhood: Decodable {
    let title: String

    enum CodingKeys: String, CodingKey {
        case title
    }
}

extension Neighborhood: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Neighborhood: Equatable {
    static func == (lhs: Neighborhood, rhs: Neighborhood) -> Bool {
        lhs.title == rhs.title
    }
}
