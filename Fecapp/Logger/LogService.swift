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

    static func logError(_ error: Error) {
        var metadata = Logger.Metadata()
        metadata["debug_description"] = .string(error.localizedDescription.debugDescription)

        if let failureReason = (error as NSError).localizedFailureReason {
            metadata["failure_reason"] = .string(failureReason)
        }

        if let recoveryOptions = (error as NSError).localizedRecoveryOptions {
            let recoveryMetadata = recoveryOptions.map { Logger.MetadataValue.string($0) }
            metadata["recovery_options"] = .array(recoveryMetadata)
        }

        if let recoverySuggestion = (error as NSError).localizedRecoveryOptions {
            let recoveryMetadata = recoverySuggestion.map { Logger.MetadataValue.string($0) }
            metadata["recovery_suggestion"] = .array(recoveryMetadata)
        }

        metadata["domain"] = .string((error as NSError).domain)
        metadata["code"] = .stringConvertible((error as NSError).code)

        shared.logger.error(error.localizedDescription.logMessage, metadata: metadata)
    }
}

extension LogService: LogServiceProtocol {
    static func trace(
        _ message: @autoclosure () -> Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.trace(message(), file: file, function: function, line: line)
    }

    static func debug(
        _ message: @autoclosure () -> Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.debug(
            message(),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }

    static func info(
        _ message: @autoclosure () -> Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.info(
            message(),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }

    static func warning(
        _ message: @autoclosure () -> Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.warning(
            message(),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }

    static func error(
        _ message: @autoclosure () -> Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        shared.logger.error(
            message(),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }
}
