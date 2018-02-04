//
//  Settings.swift
//  Template
//
//  Created by Cezary Wojcik on 1/6/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

class Settings {

    enum Key: String {

        case firstTimeSetupComplete

    }

    // MARK: - properties

    private unowned let app: App
    private var settingsStorage: [String: String] = [:]
    private let serialAccessQueue = DispatchQueue(label: "\(App.Constant.appName).Settings.serialAccessQueue")
    private let semaphore = DispatchSemaphore(value: 1)

    // MARK: - initialization

    init(app: App) {
        self.app = app
        self.synchronize()
    }

    // MARK: - api

    func synchronize() {
        self.semaphore.wait()
        self.serialAccessQueue.async {
            self.settingsStorage = [:]
        }
        self.app.database.loadAll(ofType: Setting.self) { settingsResult in
            guard case .success(let models) = settingsResult else {
                self.semaphore.signal()
                return
            }
            self.serialAccessQueue.async {
                for model in models {
                    self.settingsStorage[model.key] = model.value
                }
                self.semaphore.signal()
            }
        }
    }

    func value(for key: Key) -> String? {
        self.semaphore.wait()
        return self.serialAccessQueue.sync {
            let value = self.settingsStorage[key.rawValue]
            self.semaphore.signal()
            return value
        }
    }

    func saveValue(_ value: String, for key: Key) {
        let setting = Setting(key: key.rawValue, value: value)
        self.app.database.saveOrInsertModel(setting) { [weak self] (error) in
            if let error = error {
                self?.app.log.error("Error saving setting \(key)-\(value): \(error)")
                return
            }
            self?.serialAccessQueue.async { [weak self] in
                self?.settingsStorage[key.rawValue] = value
            }
        }
    }

    func boolean(for key: Key) -> Bool {
        return self.value(for: key) == "true"
    }

    func saveBoolean(_ boolean: Bool, for key: Key) {
        self.saveValue(boolean ? "true" : "false", for: key)
    }

}
