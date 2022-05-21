//
//  NewsDetailViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Foundation
import Markdown

class NewsDetailViewModel {
    let view: NewsDetailView

    init(view: NewsDetailView, summary: NewsSummary, body: String) {
        self.view = view

        let document = Document(parsing: body)
        var markdown = Markdownosaur()
        view.textView.attributedText = markdown.attributedString(from: document)
    }
}
