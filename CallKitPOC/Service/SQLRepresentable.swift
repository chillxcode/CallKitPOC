//
//  SQLRepresentable.swift
//  CallKitPOC
//
//  Created by Emre Celik on 13.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import Foundation
import SQLite

protocol SQLRepresentable {
    associatedtype Model
    var table: Table { get }
    func createTable()
    func insert(model: Model)
    func selectAll() -> [Model]
    func select(model: Model) -> Model?
    func deleteAll()
    func delete(model: Model)
}
