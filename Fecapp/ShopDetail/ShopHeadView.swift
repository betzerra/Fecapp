//
//  ShopHeadView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class ShopHeadView: UIView {
    let viewModel: ShopDetailViewModel

    // Subviews
    private let containerStackView: UIStackView

    private let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let instagramLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    // UI Constants
    private let horizontalPadding: CGFloat = 16.0
    private let spacing: CGFloat = 8.0

    init(viewModel: ShopDetailViewModel) {
        self.viewModel = viewModel

        containerStackView = UIStackView(
            arrangedSubviews: [addressLabel, instagramLabel]
        )

        super.init(frame: .zero)

        addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = spacing

        setupLayout()
        updateContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalPadding),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalPadding)
        ])
    }

    private func updateContent() {
        addressLabel.attributedText = viewModel.attributedAddress
        instagramLabel.attributedText = viewModel.attributedInstagram
    }
}
