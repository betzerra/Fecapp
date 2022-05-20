//
//  NSAttributedText+Symbol.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init(string: String, leadingImage: UIImage) {
        let attachment = NSTextAttachment(image: leadingImage)
        let output = NSMutableAttributedString(attachment: attachment)
        output.append(NSAttributedString(string: " \(string)"))

        self.init(attributedString: output)
    }

    convenience init(leadingBold: String, string: String) {
        let output = NSMutableAttributedString(string: leadingBold)
        output.addAttribute(
            .font, value: UIFont.preferredFont(forTextStyle: .body).bold(),
            range: NSRange.init(location: 0, length: leadingBold.utf16.count)
        )

        output.append(NSAttributedString(string: string))

        self.init(attributedString: output)
    }
}
