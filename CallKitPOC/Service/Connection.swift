//
//  Connection.swift
//  CallKitPOC
//
//  Created by Emre Celik on 13.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import Foundation
import SQLite

extension Connection {
    public var userVersion: Int32 {
        get {
            do {
                let defaultVersion = Constants.SQL.version
                let version = try scalar("PRAGMA user_version")
                return version as? Int32 ?? defaultVersion
            } catch {
                print("error \(error.localizedDescription)")
                return Constants.SQL.version
            }
        }
        set {
            do {
                try run("PRAGMA user_version = \(newValue)")
            } catch {
                print("error \(error.localizedDescription)")
            }
        }
    }
}
