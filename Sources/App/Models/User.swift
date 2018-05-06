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
import Authentication

extension User: Content { }
extension User: Migration { }
/*extension User: Timestampable {
    static var createdAtKey: WritableKeyPath<User, Date?> { return \User.created_at }
    static var updatedAtKey: WritableKeyPath<User, Date?> { return \User.updated_at }
}*/

extension User: BasicAuthenticatable {
    static var usernameKey: UsernameKey { return \User.email }
    static var passwordKey: PasswordKey { return \User.password }
}

final class User: PostgreSQLModel {
    var id: Int?
    var email: String
    var displayName: String
    var password: String
   // var created_at: Date?
   // var updated_at: Date?

    init(email: String, displayName: String, password: String) {
        self.email = email
        self.displayName = displayName
        self.password = password
    }
    
    func newUserWithHashedPassword(with request: Request) throws -> User {
        let hasher = try request.make(BCryptDigest.self)
        let passwordHashed = try hasher.hash(self.password)
        return User(email: self.email, displayName: self.displayName, password: passwordHashed)
    }
}
