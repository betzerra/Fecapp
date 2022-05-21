//
//  NewsDetailView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Foundation
import UIKit

class NewsDetailView: UIView {
    let textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.isEditable = false
        return view
    }()

    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    init() {
        super.init(frame: .zero)
        textView.loadInto(containerView: self, insets: insets)
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
