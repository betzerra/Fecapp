//
//  MetadataLoggeable.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 09/05/2022.
//

import Foundation
import Logging

protocol MetadataLoggeable {
    var logMetadata: Logger.Metadata { get }
}

extension Array: MetadataLoggeable where Element == Shop {
    var logMetadata: Logger.Metadata {
        var metadata = Logger.Metadata()
        metadata["count"] = .stringConvertible(self.count)
        metadata["items"] = .array(self.map { .string( $0.title ) })
        return metadata
    }
}
