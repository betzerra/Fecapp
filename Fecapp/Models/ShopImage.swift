//
//  ShopThumbnail.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 24/04/2022.
//

import Foundation

struct ShopThumbnail: Decodable {
    let regular: URL
    let small: URL

    enum CodingKeys: String, CodingKey {
        case regular = "url"
        case small = "thumb"
    }

    enum ThumbnailCodingKeys: String, CodingKey {
        case url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        regular = try values.decode(URL.self, forKey: .regular)

        let thumbnailContainer = try values.nestedContainer(
            keyedBy: ThumbnailCodingKeys.self,
            forKey: .small
        )
        small = try thumbnailContainer.decode(URL.self, forKey: .url)
    }
}
