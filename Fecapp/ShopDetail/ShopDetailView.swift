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

    let addressButton: UIButton = {
        return ShopDetailView.detailButton()
    }()

    let instagramButton: UIButton = {
        return ShopDetailView.detailButton()
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
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        return label
    }()

    private let stackView: UIStackView
    private let detailStackView: UIStackView

    private let padding: CGFloat = 16

    init() {
        self.detailStackView = UIStackView(
            arrangedSubviews: [
                addressButton,
                instagramButton,
                messageTitleLabel,
                messageBodyLabel
            ]
        )
        self.detailStackView.axis = .vertical
        self.detailStackView.spacing = 8
        self.detailStackView.layoutMargins = UIEdgeInsets(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        self.detailStackView.isLayoutMarginsRelativeArrangement = true

        self.headView = ShopHeadView()
        self.stackView = UIStackView(
            arrangedSubviews: [headView, detailStackView]
        )
        self.stackView.axis = .vertical

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

    static func detailButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }
}
