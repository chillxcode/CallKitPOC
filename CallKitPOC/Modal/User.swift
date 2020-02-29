//
//  User.swift
//  CallKitPOC
//
//  Created by Emre Celik on 12.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import Foundation

final class User {
    var id: Int
    var name: String
    var phone: Int64
    
    init(id: Int, name: String, phone: Int64) {
        self.id = id
        self.name = name
        self.phone = phone
    }
}
