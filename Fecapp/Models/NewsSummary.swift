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
    let date: Date
    let url: URL
}
