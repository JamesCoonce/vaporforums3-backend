//
//  AccessToken.swift
//  App
//
//  Created by Stephen Bodnar on 5/10/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class AccessToken: PostgreSQLModel  {

    var id: Int?
    var token: String
    var role: String
    var isValid: Bool
    var lastUsedDate: Date
    var created_at: Date?
    var updated_at: Date?
    var userID: User.ID
    
    init(token: String, role: String, isValid: Bool, lastUsedDate: Date, userID: User.ID) {
        self.token = token
        self.role = role
        self.isValid = isValid
        self.lastUsedDate = lastUsedDate
        self.userID = userID
    }
    
    static func generateAccessToken(for user: User)  throws -> AccessToken {
        let token = Helpers.randomToken(withLength: 60)
        return try AccessToken(token: token, role: User.Role.user, isValid: true, lastUsedDate: Date(), userID: user.requireID())
    }
}

extension AccessToken: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<AccessToken, String> { return \AccessToken.token }
}

extension AccessToken: Authentication.Token {
    static var userIDKey: WritableKeyPath<AccessToken, User.ID> { return \AccessToken.userID } // 1
    typealias UserType = User // 2
    typealias UserIDType = User.ID //3
}

extension AccessToken {
    var user: Parent<AccessToken, User> {
        return parent(\.userID)
    }
}

extension AccessToken: Timestampable {
    static var createdAtKey: WritableKeyPath<AccessToken, Date?> { return \AccessToken.created_at }
    static var updatedAtKey: WritableKeyPath<AccessToken, Date?> { return \AccessToken.updated_at }
}

// Empty Extensions
extension AccessToken: Content { }
extension AccessToken: Migration { }

