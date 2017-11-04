//
//  Setting.swift
//  Template
//
//  Created by Cezary Wojcik on 1/6/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

struct Setting: DatabaseModel {

    // MARK: - database model

    static let primaryKey = "key"
    static let tableName = "settings"

    // MARK: - properties

    let key: String
    let value: String

    var values: [String: Any?] {
        return [
            "key": self.key,
            "value": self.value
        ]
    }

    // MARK: - initialization

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    init?(app: App, databaseValues: [String: Any]) {
        guard let key = databaseValues["key"] as? String,
            let value = databaseValues["value"] as? String else {
                app.log.assertFailure("Failed to initialize Setting with values \(databaseValues)")
            return nil
        }
        self.key = key
        self.value = value
    }

}
