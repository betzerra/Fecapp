//
//  RoundedButton.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 14/05/2022.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
