//
//  App.swift
//  Template
//
//  Created by Cezary Wojcik on 1/6/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

class App {

    // MARK: - constants

    enum Constant {

        static let appName = "Template"

    }

    // MARK: - properties

    weak var rootViewController: RootViewController?

    let log = Log()
    lazy var database = Database(app: self)
    lazy var settings = Settings(app: self)

    // MARK: - initialization

    init() { }

    // MARK: - api

    func configure() {
        self.database.configure()
        if !self.settings.boolean(for: .firstTimeSetupComplete) {
            self.firstTimeSetup()
        }
    }

    // MARK: - private helpers

    private func firstTimeSetup() {
        // on completion:
        self.settings.saveBoolean(true, for: .firstTimeSetupComplete)
    }

}
