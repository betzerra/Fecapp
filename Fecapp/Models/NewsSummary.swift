//
//  NewsSummary.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Foundation

struct NewsSummary: Decodable, Hashable {
    let title: String
    let subtitle: String
    let author: String
    let authorThumbnail: URL
    let date: Date
    let url: URL

    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case author
        case authorThumbnail
        case date
        case url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        author = try values.decode(String.self, forKey: .author)
        authorThumbnail = try values.decode(URL.self, forKey: .authorThumbnail)
        date = try values.decode(Date.self, forKey: .date)
        url = try values.decode(URL.self, forKey: .url)
    }
}
