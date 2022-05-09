//
//  MessageLoggeable.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 09/05/2022.
//

import Foundation
import Logging

protocol MessageLoggeable {
    var logMessage: Logger.Message { get }
}

extension String: MessageLoggeable {
    var logMessage: Logger.Message {
        Logger.Message(stringLiteral: "\(self)")
    }
}
