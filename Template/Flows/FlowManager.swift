//
//  FlowManager.swift
//  Template
//
//  Created by Cezary Wojcik on 2/3/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

class FlowManager {

    private unowned let app: App
    private let queue: ProcedureQueue = {
        let queue = ProcedureQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

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
