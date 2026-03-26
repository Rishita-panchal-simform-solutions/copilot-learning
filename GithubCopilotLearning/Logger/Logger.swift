//
//  Logger.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import Logging
/// Logger instance for logging in the application
/// https://github.com/apple/swift-log
///
/// **Instructing SwiftLog to use logging backend**
///
/// By default the `Logger` uses stdout to dump the logs.
/// You can provide your own log handler by confirming to `LogHandler` protocol (value types are recommended for logging backend)
///
/// if you have your own logging backend then set it using below snippet in your `AppDelegate`
/// ```swift
/// LoggingSystem.bootstrap(MyLogHandler.factory)
/// ```
///
/// *Below one is the most redundant example which you can modify as per your need.*
/// ```swift
/// struct MyLogHandler: LogHandler {
///
///     let label: String
///     var metadata: Logger.Metadata = Logger.Metadata()
///     var logLevel: Logger.Level = .info
///
///     subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
///         get {
///             return metadata[metadataKey]
///         }
///         set(newValue) {
///             metadata[metadataKey] = newValue
///         }
///     }
///
///     // swiftlint:disable function_parameter_count
///     func log(level: Logger.Level,
///              message: Logger.Message,
///              metadata: Logger.Metadata?,
///              source: String, file: String,
///              function: String,
///              line: UInt) {
///         print(message)
///     }
///
///     static func factory(label: String) -> MyLogHandler {
///         return MyLogHandler(label: label)
///     }
/// }
/// ```
let log = Logger(label: "com.simformsolutions")
// MARK: String logging extension
extension String {
    /// Convert strings to `Logger.Message`
    var log: Logger.Message {
        return "\(self)"
    }
}