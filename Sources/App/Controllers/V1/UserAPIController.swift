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

final class UserAPIController {
    
    func getAll(_ request: Request) throws -> Future<[User.PublicUser]> {
        return User.query(on: request).all().map(to: [User.PublicUser].self) { users  in
            let publicUsers = try users.publicUsers()
            return publicUsers
        }
    }
    
    func createUser(_ request: Request) throws -> Future<User.AuthenticatedUser> {
        return try request.content.decode(User.self).flatMap(to: User.AuthenticatedUser.self) { (user) -> Future<User.AuthenticatedUser> in
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



