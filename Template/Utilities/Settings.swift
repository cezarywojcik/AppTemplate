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

    // MARK: - initialization

    init(app: App) {
        self.app = app
        self.synchronize()
    }

    // MARK: - api

    func synchronize() {
        self.serialAccessQueue.async { [weak self] in
            self?.settingsStorage = [:]
        }
        self.app.database.loadAll(ofType: Setting.self) { [weak self] (models, error) in
            self?.serialAccessQueue.async { [weak self] in
                for model in models {
                    self?.settingsStorage[model.key] = model.value
                }
            }
        }
    }

    func value(for key: Key) -> String? {
        return self.serialAccessQueue.sync {
            self.settingsStorage[key.rawValue]
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
