//
//  UserController.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import Authentication
import Crypto

final class UserController {
    
    func createUser(_ request: Request) throws -> Future<User.AuthenticatedUser> {
        let futureUser = try request.content.decode(User.self)
        return futureUser.flatMap(to: User.AuthenticatedUser.self) { (user) -> Future<User.AuthenticatedUser> in
            let hasher = try request.make(BCryptDigest.self)
            let passwordHashed = try hasher.hash(user.password)
            let newUser = User(email: user.email, displayName: user.displayName, password: passwordHashed)
            return newUser.save(on: request).map(to: User.AuthenticatedUser.self) { authedUser in
                return try User.AuthenticatedUser(email: authedUser.email, id: authedUser.requireID(), displayName: authedUser.displayName, token: "token here")
            }
        }
    }
  
    func loginUser(_ request: Request) throws -> User.AuthenticatedUser {
        let user = try request.requireAuthenticated(User.self)
        return try User.AuthenticatedUser(email: user.email, id: user.requireID(), displayName: user.displayName, token: "token here")
    }
    
}

