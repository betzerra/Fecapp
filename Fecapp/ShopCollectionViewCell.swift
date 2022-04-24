//
//  ShopCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 24/04/2022.
//

import Foundation
import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    var stackView: UIStackView!

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .label
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    func addViews() {
        stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }

    func setShop(_ shop: Shop) {
        titleLabel.text = shop.title
        subtitleLabel.text = shop.address
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
