//
//  Log.swift
//  Template
//
//  Created by Cezary Wojcik on 1/6/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Log {

    // MARK: - initialization

    init() {
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24 * 7) // 7 days
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    // MARK: - properties

    var logFileDataArray: [Data] {
        get {
            guard let ddFileLogger = DDLog.allLoggers.filter({ $0 is DDFileLogger }).first as? DDFileLogger else {
                return []
            }
            let logFilePaths = ddFileLogger.logFileManager.sortedLogFilePaths as [String]
            var logFileDataArray: [Data] = []
            for logFilePath in logFilePaths.reversed() {
                let fileURL = URL(fileURLWithPath: logFilePath)
                if let logFileData = try? Data(contentsOf: fileURL, options: Data.ReadingOptions.mappedIfSafe) {
                    logFileDataArray.append(logFileData)
                }
            }
            return logFileDataArray
        }
    }

    // MARK: - log functions

    func debug(_ message: String,
               file: StaticString = #file,
               function: StaticString = #function,
               line: Int = #line) {
        DDLogDebug("\(file)-\(function)-\(line): \(message)")
    }

    func assertFailure(_ message: String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: Int = #line) {
        let failureMessage = "\(file)-\(function)-\(line): \(message)"
        DDLogDebug("\(file)-\(function)-\(line): \(message)")
        assertionFailure(failureMessage)
    }

    func info(_ message: String,
              file: StaticString = #file,
              function: StaticString = #function,
              line: Int = #line) {
        DDLogInfo("\(file)-\(function)-\(line): \(message)")
    }

    func error(_ message: String,
               file: StaticString = #file,
               function: StaticString = #function,
               line: Int = #line) {
        DDLogError("\(file)-\(function)-\(line): \(message)")
    }

}
