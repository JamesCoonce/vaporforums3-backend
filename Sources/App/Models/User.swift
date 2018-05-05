//
//  User.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import FluentPostgreSQL
import Vapor

extension User: Content { }
extension User: Migration { }

final class User: PostgreSQLModel {
    var id: Int?
    var email: String
    var username: String
    var password: String
    
    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }
}
