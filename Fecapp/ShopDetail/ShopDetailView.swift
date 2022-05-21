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

    let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.isUserInteractionEnabled = true
        return label
    }()

    let instagramButton: UIButton = {
        return UIButton.detailButton()
    }()

    let roasterButton: UIButton = {
        return UIButton.detailButton()
    }()

    let menuButton: UIButton = {
        let button = UIButton(configuration: .standardFill())
        button.translatesAutoresizingMaskIntoConstraints = false

        // Normal state
        let normalImage = UIImage(systemName: "menucard")?
            .withTintColor(.buttonTitle, renderingMode: .alwaysOriginal)
        button.setTitle("Ver Menú", for: .normal)
        button.setTitleColor(.buttonTitle, for: .normal)
        button.setImage(normalImage, for: .normal)

        // Disabled state
        let disabledImage = UIImage(systemName: "menucard")
        button.setTitle("Menu no disponible", for: .disabled)
        button.setImage(disabledImage, for: .disabled)

        button.isEnabled = false // disabled by default (viewcontroller will update it later)
        return button
    }()

    private let stackView: UIStackView

    private let padding: CGFloat = 16

    init() {
        let detailStackView = UIStackView(
            arrangedSubviews: [
                addressLabel,
                instagramButton,
                roasterButton,
                menuButton
            ]
        )
        detailStackView.axis = .vertical
        detailStackView.spacing = 8
        detailStackView.layoutMargins = UIEdgeInsets(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        detailStackView.isLayoutMarginsRelativeArrangement = true
        detailStackView.setCustomSpacing(0, after: instagramButton)

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
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
