//
//  ShopDetailView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import UIKit

class ShopDetailView: UIView {
    let headView: ShopHeadView

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let messageTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()

    let messageBodyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let stackView: UIStackView

    init() {
        self.headView = ShopHeadView()
        self.stackView = UIStackView(
            arrangedSubviews: [headView, messageTitleLabel, messageBodyLabel]
        )
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill

        super.init(frame: .zero)

        scrollView.loadInto(containerView: self)

        addSubviews()
        setupLayout()

        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = stackView.bounds.size
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
