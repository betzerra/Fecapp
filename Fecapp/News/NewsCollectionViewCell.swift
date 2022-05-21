//
//  NewsCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Foundation
import UIKit

private let authorImageViewSize: CGFloat = 20.0
private let fontName = "Avenir Next"

class NewsCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.font(name: fontName, forTextStyle: .headline).bold()
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.font(name: fontName, forTextStyle: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.font(name: fontName, forTextStyle: .caption2)
        label.textColor = .quaternaryLabel
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.font(name: fontName, forTextStyle: .caption2)
        label.textColor = .tertiaryLabel
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    let authorImageView: UIImageView = {
        let imageView = RoundedImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: authorImageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: authorImageViewSize)
        ])

        return imageView
    }()

    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 8, right: 16)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        let bottomViews = [authorImageView, authorLabel, dateLabel]
        let bottomStackView = UIStackView(arrangedSubviews: bottomViews)
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.spacing = 8

        let views = [titleLabel, subtitleLabel, bottomStackView]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.loadInto(containerView: self, insets: padding)
        stackView.axis = .vertical
        stackView.spacing = 8
    }
}
