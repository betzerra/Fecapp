//
//  LocationOnboardingView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Foundation
import UIKit

class LocationOnboardingView: UIView {
    private let horizontalPadding: CGFloat = 24
    private let symbolPointSize: CGFloat = 64
    private let spacing: CGFloat = 16
    private let smallerSpacing: CGFloat = 4

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

    let agreeButton: UIButton = {
        let button = UIButton(configuration: .filled())
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()

    override init(frame: CGRect) {
        let buttonsStackView = UIStackView(arrangedSubviews: [
            agreeButton, cancelButton
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

        super.init(frame: frame)

        addSubview(contentStackView)

        backgroundColor = .systemBackground

        setupLayout()
        setupContent()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalPadding),
            contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalPadding),
            contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    func setupContent() {
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: symbolPointSize,
            weight: .medium
        )

        symbolImageView.image =  UIImage(
            systemName: "location.circle",
            withConfiguration: symbolConfiguration
        )

        titleLabel.text = "Necesitamos saber tu ubicación"
        subtitleLabel.text = "Para mostrarte cafeterías cerca tuyo, necesitamos saber dónde estás."

        agreeButton.setTitle("Continuar", for: .normal)
        cancelButton.setTitle("No quiero compartir", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
