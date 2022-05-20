//
//  Roaster.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation

struct Roaster: Decodable, Equatable {
    let id: Int
    let title: String
    let instagram: String
    let shipsOutsideCABA: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case instagram
        case title
        case shipsOutsideCABA = "shipsOutsideCaba"
    }
}
