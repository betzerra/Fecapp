//
//  ShopCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 24/04/2022.
//

import CoreLocation
import Foundation
import UIKit
import SDWebImage

class ShopCollectionViewCell: UICollectionViewCell {
    // UI constants
    private let thumbnailVerticalMargin: CGFloat = 8.0
    private let horizontalSpacing: CGFloat = 16.0
    private let verticalSpacing: CGFloat = 4.0

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textColor = .secondaryLabel
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    func addViews() {
        addSubview(imageView)

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            UIView()
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = verticalSpacing
        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: thumbnailVerticalMargin),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: horizontalSpacing),
            stackView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: verticalSpacing),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor)
        ])
    }

    func setViewModel(_ viewModel: ShopCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.attributedText = viewModel.attributedSubtitle

        if let thumbnail = viewModel.shop.thumbnail?.small {
            imageView.sd_setImage(with: thumbnail)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
