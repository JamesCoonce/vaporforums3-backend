//
//  AccessToken.swift
//  App
//
//  Created by Stephen Bodnar on 5/10/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Crypto

final class AccessToken: PostgreSQLModel {
    
    var id: Int?
    var token: String
    var role: String
    var isValid: Bool
    var lastUsedDate: Date
    var createdAt: Date?
    var updatedAt: Date?
    var userID: User.ID
    
    init(token: String, role: String, isValid: Bool, lastUsedDate: Date, userID: User.ID) {
        self.token = token
        self.role = role
        self.isValid = isValid
        self.lastUsedDate = lastUsedDate
        self.userID = userID
    }
    
    fileprivate class func generateAccessToken(for user: User)  throws -> AccessToken {
        let token = Helpers.randomToken(withLength: 60)
        return try AccessToken(token: token, role: User.Role.user, isValid: true, lastUsedDate: Date(), userID: user.requireID())
    }
}

// Extensions
extension AccessToken: Content { }
extension AccessToken: Migration { }
extension AccessToken: Timestampable {
    static var createdAtKey: WritableKeyPath<AccessToken, Date?> { return \AccessToken.createdAt }
    static var updatedAtKey: WritableKeyPath<AccessToken, Date?> { return \AccessToken.updatedAt }
}
