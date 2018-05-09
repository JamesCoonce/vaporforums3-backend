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

extension User: Timestampable {
    static var createdAtKey: WritableKeyPath<User, Date?> {
        return \User.createdAt
    }
    
    static var updatedAtKey: WritableKeyPath<User, Date?> {
        return \User.updatedAt
    }
}

extension User: BasicAuthenticatable {
    static var usernameKey: UsernameKey { return \User.email }
    static var passwordKey: PasswordKey { return \User.password }
}

final class User: PostgreSQLModel {
    var id: Int?
    var email: String
    var displayName: String
    var password: String
    var createdAt: Date?
    var updatedAt: Date?

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
    
    fileprivate func createPublicUser() throws -> User.PublicUser {
        return try User.PublicUser(email: self.email, id: self.requireID(), displayName: self.displayName)
    }
}

extension Array where Element:User {
    func publicUsers() throws -> [User.PublicUser] {
        var publicUsers = [User.PublicUser]()
        for user in self { try publicUsers.append(user.createPublicUser()) }
        return publicUsers
    }
}
