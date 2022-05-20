//
//  RoasterHeaderView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

class RoasterHeaderView: UICollectionReusableView {
    let padding = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
    let spacing: CGFloat = 8

    let instagramButton: UIButton = {
        return UIButton.detailButton()
    }()

    let shippingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        if let image = UIImage(systemName: "shippingbox") {
            label.attributedText = NSAttributedString(string: "Envíos a todo el país", leadingImage: image)
        } else {
            label.text = "Envíos a todo el país"
        }

        return label
    }()

    let coffeeShopsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        let stackView = UIStackView(
            arrangedSubviews: [instagramButton, shippingLabel, coffeeShopsLabel]
        )
        stackView.spacing = spacing
        stackView.axis = .vertical
        stackView.setCustomSpacing(24, after: shippingLabel)
        stackView.loadInto(containerView: self, insets: padding, priority: .required)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
