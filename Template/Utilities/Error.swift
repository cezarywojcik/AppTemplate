//
//  Error.swift
//  Template
//
//  Created by Cezary Wojcik on 2/3/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

struct Error: Swift.Error {

    let message: String
    let associatedError: Swift.Error?
    let file: StaticString
    let function: StaticString
    let line: Int

    init(_ message: String = "",
         associatedError: Swift.Error? = nil,
         app: App,
         file: StaticString = #file,
         function: StaticString = #function,
         line: Int = #line) {
        self.message = message
        self.associatedError = associatedError
        self.file = file
        self.function = function
        self.line = line
        // automatically log errors on initialization
        app.log.error(error: self)
    }

}
