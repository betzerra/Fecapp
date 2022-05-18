//
//  LabelCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    // UI Constants
    private let verticalPadding: CGFloat = 6.0
    private let horizontalPadding: CGFloat = 12.0

    override var isSelected: Bool {
        didSet {
            setupStyle(isSelected: isSelected)
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupStyle(isSelected: false)
    }

    func addViews() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding)
        ])
    }

    func setupStyle(isSelected: Bool) {
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0

        if isSelected {
            titleLabel.textColor = .white
            backgroundColor = .primary
            layer.borderColor = UIColor.primary.cgColor
        } else {
            titleLabel.textColor = .label
            backgroundColor = .systemBackground
            layer.borderColor = UIColor.label.cgColor
        }
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
