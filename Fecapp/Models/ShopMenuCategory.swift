//
//  ShopMenuCategory.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation

struct ShopMenuCategory: Decodable {
    let title: String
    let items: [ShopMenuItem]
}

extension ShopMenuCategory: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension ShopMenuCategory: Equatable {
    static func == (lhs: ShopMenuCategory, rhs: ShopMenuCategory) -> Bool {
        lhs.title == rhs.title
    }
}
