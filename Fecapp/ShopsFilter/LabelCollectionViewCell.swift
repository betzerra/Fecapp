//
//  LabelCollectionViewCell.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class LabelCollectionViewCell: UICollectionViewCell {

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
    }

    func addViews() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
