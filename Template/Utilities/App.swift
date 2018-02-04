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
    lazy var flow = FlowManager(app: self)
    lazy var database = Database(app: self)
    lazy var settings = Settings(app: self)

    // MARK: - initialization

    init() { }

    // MARK: - api

    func configure() {
        self.database.configure()
    }

}
