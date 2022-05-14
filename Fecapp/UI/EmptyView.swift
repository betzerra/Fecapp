//
//  EmptyView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 14/05/2022.
//

import Foundation
import UIKit

private let symbolSize: CGFloat = 48.0
private let spacing: CGFloat = 16.0

class EmptyView: UIView {
    let imageView: UIImageView = {
        let image = UIImage(
            systemName: "hourglass.circle",
            withConfiguration: EmptyView.defaultSymbolConfiguration
        )?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemGray4)

        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = DummyQuotes.quotes.randomElement()
        return label
    }()

    static var defaultSymbolConfiguration: UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .medium)
    }

    init() {
        super.init(frame: .zero)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = spacing
        stackView.loadInto(containerView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
