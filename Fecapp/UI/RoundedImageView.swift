//
//  RounderImageView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 11/05/2022.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
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
    }
}
