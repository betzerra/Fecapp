//
//  ShopDetail.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation

class ShopDetail: Decodable {
    let shop: Shop
    let menu: [ShopMenuCategory]

    init(shop: Shop, menu: [ShopMenuCategory]) {
        self.shop = shop
        self.menu = menu
    }
}
