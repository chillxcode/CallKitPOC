//
//  SQLInfoModel.swift
//  CallKitPOC
//
//  Created by Emre Celik on 13.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import Foundation
import SQLite

final class SQLInfoModel {
    var info: String?
}

extension SQLInfoModel {
    static let info = Expression<String?>("info")
}

extension SQLInfoModel: SQLRepresentable {
    typealias Model = SQLInfoModel
    var table: Table {
        return Table("SQLInfoModel")
    }
    
    func createTable() {
        do {
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(table.create(ifNotExists: true) { t in
                t.column(SQLInfoModel.info)
            })
        } catch let error {
            print("error create \(error.localizedDescription)")
        }
    }
    
    func insert(model: SQLInfoModel) {
        do {
            createTable()
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(
                table.insert(
                    SQLInfoModel.info <- model.info
                )
            )
        } catch let error {
            print("error insert \(error.localizedDescription)")
        }
    }
    
    func selectAll() -> [SQLInfoModel] {
        do {
            createTable()
            var infos: [SQLInfoModel] = []
            guard let db = SQLManager().connectDatabase() else { return [] }
            infos = try db.prepare(table).map { row in
                let info = SQLInfoModel()
                info.info = try row.get(SQLInfoModel.info)
                return info
            }
            return infos
        } catch let error {
            print("error select all \(error.localizedDescription)")
            return []
        }
    }
    
    func select(model: SQLInfoModel) -> SQLInfoModel? { return nil }
    
    func select() -> SQLInfoModel? { return nil }
    
    func deleteAll() {
        do {
            createTable()
            guard let db = SQLManager().connectDatabase() else { return }
            try db.run(table.delete())
        } catch let error {
            print("deleteAll error \(error.localizedDescription)")
        }
    }
    
    func delete(model: SQLInfoModel) {}
}
