//
//  LogService.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 09/05/2022.
//

import Foundation
import Logging
import Puppy

class LogService {
    static let shared: LogService = LogService()
    let logger: Logger

    private let consoleLabel = "com.betzerra.coffee.console"
    private let swiftLogLabel = "com.betzerra.coffee.swiftlog"

    init() {
        let console = ConsoleLogger(consoleLabel)
        console.logLevel = .debug
        console.format = LogFormatter()

        let puppy = Puppy.default
        puppy.add(console)

        LoggingSystem.bootstrap { label in
            var handler = PuppyLogHandler(label: label, puppy: puppy)
            handler.logLevel = .debug
            return handler
        }

        logger = Logger(label: swiftLogLabel)
    }
}

extension LogService: LogServiceProtocol {
    static func trace(
        _ message: @autoclosure () -> Message,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.trace(message(), file: file, function: function, line: line)
    }

    static func debug(
        _ message: @autoclosure () -> Message,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.debug(message(), file: file, function: function, line: line)
    }

    static func info(
        _ message: @autoclosure () -> Message,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.info(message(), file: file, function: function, line: line)
    }

    static func warning(
        _ message: @autoclosure () -> Message,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.warning(message(), file: file, function: function, line: line)
    }

    static func error(
        _ message: @autoclosure () -> Message,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.error(message(), file: file, function: function, line: line)
    }
}
