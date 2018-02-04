//
//  Flow.swift
//  Template
//
//  Created by Cezary Wojcik on 2/3/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation
import ProcedureKit

class Flow: Procedure {

    unowned let app: App

    init(app: App) {
        self.app = app
        super.init()
        self.qualityOfService = .userInteractive
    }

    final override func execute() {
        DispatchQueue.main.async {
            self.executeOnMainThread()
        }
    }

    func executeOnMainThread() {
        self.app.log.assertFailure("\(#function) needs to be overridden by subclass")
    }

}
