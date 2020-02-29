//
//  SQLUserModel.swift
//  CallKitPOC
//
//  Created by Emre Celik on 13.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import Foundation
import SQLite

final class SQLUserModel {
    var name: String?
    var phone: Int64?
}

extension SQLUserModel {
    static let name = Expression<String?>("name")
    static let phone = Expression<Int64?>("phone")
}

extension SQLUserModel: SQLRepresentable {
    typealias Model = SQLUserModel
    var table: Table {
        return Table("SQLUserModel")
    }
    
    func createTable() {
        do {
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(table.create(ifNotExists: true) { t in
                t.column(SQLUserModel.name)
                t.column(SQLUserModel.phone)
            })
        } catch let error {
            print("error create \(error.localizedDescription)")
        }
    }
    
    func insert(model: SQLUserModel) {
        do {
            createTable()
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(
                table.insert(
                    SQLUserModel.name <- model.name,
                    SQLUserModel.phone <- model.phone
                )
            )
        } catch let error {
            print("error insert \(error.localizedDescription)")
        }
    }
    
    func selectAll() -> [SQLUserModel] {
        do {
            createTable()
            var users: [SQLUserModel] = []
            guard let db = SQLManager().connectDatabase() else { return [] }
            users = try db.prepare(table).map { row in
                let user = SQLUserModel()
                user.name = try row.get(SQLUserModel.name)
                user.phone = try row.get(SQLUserModel.phone)
                return user
            }
            return users
        } catch let error {
            print("error select all \(error.localizedDescription)")
            return []
        }
    }
    
    func select(model: SQLUserModel) -> SQLUserModel? { return nil }
    
    func select() -> SQLUserModel? {
        do {
            createTable()
            var users: [SQLUserModel] = []
            guard let db = SQLManager().connectDatabase() else { return nil }
            users = try db.prepare(table).map { row in
                let user = SQLUserModel()
                user.name = try row.get(SQLUserModel.name)
                user.phone = try row.get(SQLUserModel.phone)
                return user
            }
            return users.first
        } catch let error {
            print("error select all \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteAll() {
        do {
            createTable()
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(table.delete())
        } catch let error {
            print("deleteAll error \(error.localizedDescription)")
        }
    }
    
    func delete(model: SQLUserModel) {
        do {
            guard let db = SQLManager().connectDatabase() else { return }
            let filter = table.filter(SQLUserModel.phone == model.phone)
            try db.run(filter.delete())
        } catch let error {
            print("delete error \(error.localizedDescription)")
        }
    }
    
}
