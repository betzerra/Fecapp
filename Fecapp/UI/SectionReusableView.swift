//
//  SectionReusableView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import UIKit

class SectionReusableView: UICollectionReusableView {
    let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        titleLabel.loadInto(containerView: self, insets: padding, priority: .required)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
