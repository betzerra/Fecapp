//
//  ShopCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 24/04/2022.
//

import Foundation
import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView!

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    func addViews() {
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        let rightStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, UIView()])
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.axis = .vertical
        rightStackView.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [imageView, rightStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 90),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setShop(_ shop: Shop) {
        titleLabel.text = shop.title
        subtitleLabel.text = shop.address
        imageView.load(url: URL(string: "https://cdn.betzerra.com/mrpoopypants/production/shop/thumbnail/98/thumb_C76C9E31-CAFA-4AEC-95C7-A9ED8C148A9C.jpeg")!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
