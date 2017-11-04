//
//  Database.swift
//  Template
//
//  Created by Cezary Wojcik on 11/6/17.
//  Copyright © 2017 Cezary Wojcik. All rights reserved.
//

import Foundation
import FMDB

class Database {

    // MARK: - constants

    private enum Constant {

        static let databaseFilename = "\(App.Constant.appName).sqlite"
        static let databaseVersion = 1
        static let databaseVersionKey = "\(App.Constant.appName).databaseVersion"

    }

    // MARK: - error

    enum Error: Swift.Error {

        case modelMissingValueForPrimaryKey

    }

    // MARK: - properties

    private unowned let app: App
    private let queue: FMDatabaseQueue
    private let serialDatabaseQueue = DispatchQueue(label: "\(App.Constant.appName).Database.serialDatabaseQueue")

    // MARK: - initialization

    init(app: App) {
        self.app = app
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = documentsURL?.appendingPathComponent(Constant.databaseFilename).absoluteString ?? ""
        self.app.log.debug("Opening database at path \"\(path)\"")
        self.queue = FMDatabaseQueue(path: path)
    }

    // MARK: - api

    /**
     Should be called on initial app load to ensure database is configured.
     */
    func configure() {
        let currentVersion = UserDefaults.standard.integer(forKey: Constant.databaseVersionKey)
        if currentVersion < Constant.databaseVersion {
            self.app.log.info("Outdated database version \(currentVersion) (expected \(Constant.databaseVersion)).")
            self.createDatabase()
        }
    }

    /**
     Asynchronously save or insert the given model into the database.
     */
    func saveOrInsertModel<Model: DatabaseModel>(_ model: Model,
                                                 completion: ((_ error: Swift.Error?) -> Void)?) {
        self.serialDatabaseQueue.async {
            self.queue.inDatabase { (database) in
                var errorOrNil: Swift.Error? = nil
                defer {
                    completion?(errorOrNil)
                }

                let valuesToSave = model.values

                guard let modelID = valuesToSave[Model.primaryKey] as? String else {
                    errorOrNil = Error.modelMissingValueForPrimaryKey
                    return
                }

                // we check to see if there are existing values
                do {
                    let resultSet = try database.executeQuery(
                        "SELECT \(Model.primaryKey) FROM \(Model.tableName) WHERE \(Model.primaryKey) = ?",
                        values: [modelID])
                    let hasResults = resultSet.next()
                    resultSet.close()

                    if hasResults {
                        // there is an existing value, so we want to update
                        let updateValuesString = valuesToSave.map({ $0.key }).joined(separator: " = ?, ")
                            + " = ?"
                        var values = valuesToSave.map({ $0.value ?? NSNull() })
                        values.append(modelID)
                        try database.executeUpdate(
                            "UPDATE \(Model.tableName) SET \(updateValuesString) WHERE \(Model.primaryKey) = ?",
                            values: values)
                    } else {
                        // there is no existing value, so insert one
                        let updateFieldsString = valuesToSave.map({ $0.key }).joined(separator: ",")
                        let questionMarks = valuesToSave.map({ _, _ in "?" }).joined(separator: ",")
                        try database.executeUpdate(
                            "INSERT INTO \(Model.tableName) (\(updateFieldsString)) VALUES (\(questionMarks))",
                            values: valuesToSave.map({ $0.value ?? NSNull() }))
                    }
                } catch {
                    errorOrNil = error
                }
            }
        }
    }

    /**
     Synchronously check if the model exists.
     */
    func modelExists<Model: DatabaseModel>(ofType type: Model.Type, withID id: String) -> Bool {
        var exists = false
        self.queue.inDatabase { (database) in
            do {
                let resultSet = try database.executeQuery(
                    "SELECT \(Model.primaryKey) FROM \(Model.tableName) WHERE \(Model.primaryKey) = ?",
                    values: [id])
                exists = resultSet.next()
                resultSet.close()
            } catch {
                self.app.log.error("Error checking whether model exists: \(error)")
            }
        }
        return exists
    }

    /**
     Asynchronously load the model with the given IDs from the database.
     */
    func load<Model: DatabaseModel>(ofType type: Model.Type,
                                    withIDList idList: [String],
                                    handler: ((_ models: [Model], _ error: Swift.Error?) -> Void)?) {
        self.serialDatabaseQueue.async {
            self.queue.inDatabase({ (database) in
                var errorOrNil: Swift.Error? = nil
                var models: [Model] = []
                defer {
                    handler?(models, errorOrNil)
                }
                let questionMarks = idList.map({ _ in "?" }).joined(separator: ",")
                do {
                    let resultSet = try database.executeQuery(
                        "SELECT * FROM \(Model.tableName) WHERE \(Model.primaryKey) IN (\(questionMarks))",
                        values: idList)
                    while resultSet.next() {
                        guard let resultDictionary = resultSet.resultDictionary as? [String: Any],
                            let model = Model(app: self.app, databaseValues: resultDictionary) else {
                                continue
                        }
                        models.append(model)
                    }
                } catch {
                    errorOrNil = error
                }
            })
        }
    }

    /**
     Asynchronously load the model with the given IDs from the database.
     */
    func load<Model: DatabaseModel>(ofType type: Model.Type,
                                    withID id: String,
                                    handler: ((_ model: Model?, _ error: Swift.Error?) -> Void)?) {
        self.load(ofType: type, withIDList: [id]) { (models, error) in
            handler?(models.first, error)
        }
    }

    /**
     Asynchronously load all models of the given type from the database.
     */
    func loadAll<Model: DatabaseModel>(ofType type: Model.Type,
                                       handler: ((_ models: [Model], _ error: Swift.Error?) -> Void)?) {
        self.serialDatabaseQueue.async {
            self.queue.inDatabase({ (database) in
                var errorOrNil: Swift.Error? = nil
                var models: [Model] = []
                defer {
                    handler?(models, errorOrNil)
                }
                do {
                    let resultSet = try database.executeQuery("SELECT * FROM \(Model.tableName)", values: [])
                    while resultSet.next() {
                        guard let resultDictionary = resultSet.resultDictionary as? [String: Any],
                            let model = Model(app: self.app, databaseValues: resultDictionary) else {
                                continue
                        }
                        models.append(model)
                    }
                } catch {
                    errorOrNil = error
                }
            })
        }
    }

    // MARK: - private helpers

    private func createDatabase() {
        guard let path = Bundle.main.path(forResource: "schema", ofType: "sql"),
            let sql = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
                fatalError("Can't get database schema.")
        }
        self.queue.inDatabase { (database) in
            guard let tablesResultSet = try? database.executeQuery(
                "SELECT * FROM sqlite_master WHERE type='table';",
                values: []) else {
                    fatalError("Can't get database and/or can't get existing tables.")
            }

            // find what tables exist so that we can drop them
            var tableNames: [String] = []
            while tablesResultSet.next() {
                if let tableName = tablesResultSet.string(forColumn: "tbl_name") {
                    tableNames.append(tableName)
                }
            }
            tablesResultSet.close()

            // drop all existing tables
            for tableName in tableNames {
                guard database.executeStatements("DROP TABLE \(tableName);") else {
                    self.app.log.error("Database error: \(database.lastError())")
                    continue
                }
            }

            // now create the new tables
            let success = database.executeStatements(sql)
            if success {
                self.app.log.info("Successfully created database of version \(Constant.databaseVersion).")
                UserDefaults.standard.set(Constant.databaseVersion, forKey: Constant.databaseVersionKey)
                UserDefaults.standard.synchronize()
            } else {
                self.app.log.assertFailure("Database error: \(database.lastError())")
            }
        }
    }

}
