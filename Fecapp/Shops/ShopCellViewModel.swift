//
//  ShopCellViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 26/04/2022.
//

import Foundation
import UIKit

struct ShopCellViewModel {
    let shop: Shop

    var title: String {
        shop.title
    }

    var subtitle: String {
        guard let neighborhood = shop.neighborhood else {
            return "N/A"
        }

        return neighborhood.title
    }
}
