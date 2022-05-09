//
//  LogServiceProtocol.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 09/05/2022.
//

import Foundation
import Logging

protocol LogServiceProtocol {
    typealias Message = Logger.Message

    // Log to the backend as a debug message.
    // Use this method to log very detailed information abour control flow that we usually don't need to see.
    static func trace(_ message: @autoclosure () -> Message, file: String, function: String, line: UInt)

    // Log to the backend as a debug message.
    // Use this method to log detailed information that is more verbose or more frequent than we usually want to see.
    static func debug(_ message: @autoclosure () -> Message, file: String, function: String, line: UInt)

    // Log to the backend as an info message.
    // Use this method to log basic information that is part of the common flow.
    static func info(_ message: @autoclosure () -> Message, file: String, function: String, line: UInt)

    // Log to the backend as a warning message.
    // Use this method to surface unexpected issues that don't actually impede any function of the app.
    static func warning(_ message: @autoclosure () -> Message, file: String, function: String, line: UInt)

    // Log to the backend as an error message, but don't show anything to the user.
    // Use this method for internal errors that do not have any significant impact on the user's experience.
    static func error(_ message: @autoclosure () -> Message, file: String, function: String, line: UInt)
}
