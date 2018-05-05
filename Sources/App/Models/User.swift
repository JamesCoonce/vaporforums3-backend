//
//  User.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import FluentPostgreSQL
import Vapor
import Crypto

extension User: Content { }
extension User: Migration { }
extension User: Timestampable {
    static var createdAtKey: WritableKeyPath<User, Date?> { return \User.created_at }
    static var updatedAtKey: WritableKeyPath<User, Date?> { return \User.updated_at }
}

final class User: PostgreSQLModel {
    var id: Int?
    var email: String
    var displayName: String
    var password: String
    var created_at: Date?
    var updated_at: Date?
    
    init(email: String, displayName: String, password: String) {
        self.email = email
        self.displayName = displayName
        self.password = password
    }
    
    func newUserWithHashedPassword() throws -> User {
        let passwordHashed = try BCrypt.hash(self.password, cost: 8)
        return User(email: self.email, displayName: self.displayName, password: passwordHashed)
    }
    
}
