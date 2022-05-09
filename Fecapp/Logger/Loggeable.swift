//
//  Loggeable.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 09/05/2022.
//

import Foundation
import Logging

protocol Loggeable {
    var toMessage: Logger.Message { get }
}

extension Loggeable {
    func toMessage(event: String) -> Logger.Message {
        return Logger.Message(stringLiteral: "\(event)\n\(self.toMessage)")
    }
}

extension String: Loggeable {
    var toMessage: Logger.Message {
        Logger.Message(stringLiteral: "\(self)")
    }
}

extension Shop: Loggeable {
    var toMessage: Logger.Message {
        Logger.Message(stringLiteral: "\(title)")
    }
}

extension Array: Loggeable where Element: Loggeable {
    var toMessage: Logger.Message {
        let output = NSMutableString()

        self.enumerated().forEach { iteration in
            let line = "-- \(iteration.offset). \(iteration.element.toMessage)\n"
            output.append(line)
        }

        return Logger.Message(stringLiteral: String(output))
    }
}
