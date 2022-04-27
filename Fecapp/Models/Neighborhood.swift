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
