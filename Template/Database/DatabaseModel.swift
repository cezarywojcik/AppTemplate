//
//  DatabaseModel.swift
//  Template
//
//  Created by Cezary Wojcik on 1/6/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

protocol DatabaseModel {

    static var primaryKey: String { get }
    static var tableName: String { get }

    var values: [String: Any?] { get }

    init?(app: App, databaseValues: [String: Any])

}
