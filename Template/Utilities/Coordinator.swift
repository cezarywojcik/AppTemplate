//
//  Coordinator.swift
//  Template
//
//  Created by Cezary Wojcik on 2/3/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

class Coordinator {

    private unowned let app: App

    // MARK: - initialization

    init(app: App) {
        self.app = app
    }

    // MARK: - api

    func appLaunch() {
        guard self.app.settings.boolean(for: .firstTimeSetupComplete) else {
            self.firstTimeSetup()
            return
        }
    }

    func appForegrounded() {

    }

    // MARK: - private helpers

    private func firstTimeSetup() {
        // on completion:
        self.app.settings.saveBoolean(true, for: .firstTimeSetupComplete)
    }

}
