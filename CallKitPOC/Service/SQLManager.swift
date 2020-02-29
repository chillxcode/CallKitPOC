//
//  SQLManager.swift
//  CallKitPOC
//
//  Created by Emre Celik on 13.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

//  .documentDirectory
///  "/var/mobile/Containers/Data/Application/802AF2CE-65F4-439A-9C4B-B60621D73D37/Documents/workplace.sqlite3"
///  "/var/mobile/Containers/Data/PluginKitPlugin/2A8FE888-B6FF-4287-BBB3-B27FC29065B7/Documents/workplace.sqlite3"

//  .documentationDirectory
///  "/var/mobile/Containers/Data/Application/B3FF45A4-B524-4A72-B4CD-2A19D03D7594/Library/Documentation/workplace.sqlite3"
///  "/var/mobile/Containers/Data/PluginKitPlugin/7E1ACA8F-38C4-4069-878B-0417F0DADFD5/Library/Documentation/workplace.sqlite3"

//  sharedContainer
/// "file:///private/var/mobile/Containers/Shared/AppGroup/B359D107-522E-4DAC-AFEB-9CD985C2897E/"
/// "file:///private/var/mobile/Containers/Shared/AppGroup/B359D107-522E-4DAC-AFEB-9CD985C2897E/"

import Foundation
import SQLite

class SQLManager {
    let databaseName = "workplace.sqlite3"
    private var _version = Constants.SQL.version
    var version: Int32 {
        get {
            db = connectDatabase()
            return db?.userVersion ?? _version
        }
        set {
            _version = newValue
            db = connectDatabase()
            db?.userVersion = newValue
        }
    }
    
    private var db: Connection?
    public var databasePath: String {
        /// Uygulama içinde sqlite3 dosyası için bunu kullanıyoruz. CallKit kullandığımız için (container aracılığı ile) dosya yolunu ortak veriyoruz.
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = FileManager.sharedContainerPath()
        let databasePath = "\(path)/\(databaseName)"
        return databasePath
    }
    
    func connectDatabase() -> Connection? {
        do {
            db = try Connection(databasePath)
            return db
        } catch let error {
            print("Database connect error \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteDatabase() {
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databasePath = "\(path)/\(databaseName)"
        do {
            try fileManager.removeItem(atPath: databasePath)
        } catch let error {
            print("Error Delete database \(error.localizedDescription)")
        }
    }
}

extension FileManager {
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.callkitPOC"
            )!
    }
    
    static func sharedContainerPath() -> String {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.callkitPOC"
            )!.absoluteString
    }
}
