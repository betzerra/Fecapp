//
//  LocationOnboardingView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Foundation
import UIKit

class LocationOnboardingView: UIView {
    let viewModel: LocationOnboardingViewModel

    // UI Constants
    private let horizontalPadding: CGFloat = 24
    private let spacing: CGFloat = 16
    private let smallerSpacing: CGFloat = 4

    // SubViews
    private let contentStackView: UIStackView

    let symbolImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let acceptButton: UIButton = {
        let button = UIButton(configuration: .filled())
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()

    init(viewModel: LocationOnboardingViewModel) {
        let buttonsStackView = UIStackView(arrangedSubviews: [
            acceptButton, cancelButton
        ])
        buttonsStackView.spacing = smallerSpacing
        buttonsStackView.axis = .vertical

        contentStackView = UIStackView(arrangedSubviews: [
            symbolImageView,
            titleLabel,
            subtitleLabel,
            buttonsStackView
        ])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = spacing
        contentStackView.axis = .vertical

        self.viewModel = viewModel

        super.init(frame: .zero)

        addSubview(contentStackView)

        backgroundColor = .systemBackground

        setupLayout()
        setupContent()

        acceptButton.addAction(viewModel.acceptAction, for: .touchUpInside)
        cancelButton.addAction(viewModel.cancelAction, for: .touchUpInside)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalPadding),
            contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalPadding),
            contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func setupContent() {
        symbolImageView.image = viewModel.image
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText

        acceptButton.setTitle(viewModel.acceptText, for: .normal)
        cancelButton.setTitle(viewModel.cancelText, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
