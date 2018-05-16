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
        return try request.content.decode(User.self).flatMap(to: User.AuthenticatedUser.self) { (user) -> Future<User.AuthenticatedUser> in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(email: user.email, displayName: user.displayName, password: passwordHashed)
            return newUser.save(on: request).flatMap(to: User.AuthenticatedUser.self) { authedUser in
                let accessToken = try AccessToken.generateAccessToken(for: authedUser)
                return accessToken.save(on: request).map(to: User.AuthenticatedUser.self) { token in
                    return try User.AuthenticatedUser(email: authedUser.email, id: authedUser.requireID(), displayName: authedUser.displayName, token: accessToken.token)
                }
            }
        }
    }
  
    func loginUser(_ request: Request) throws -> Future<User.AuthenticatedUser> {
        return try request.content.decode(User.LoginRequest.self).flatMap(to: User.AuthenticatedUser.self) { user in // 1
            let passwordVerifier = try request.make(BCryptDigest.self) // 2
            return User.authenticate(username: user.email, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)).flatMap(to: User.AuthenticatedUser.self) { authedUser in
                let newAccessToken = try AccessToken.generateAccessToken(for: authedUser)
                return newAccessToken.save(on: request).map(to: User.AuthenticatedUser.self) { newToken in
                    return try User.AuthenticatedUser(email: authedUser.email, id: authedUser.requireID(), displayName: authedUser.displayName, token: newToken.token)
                }
            }
        }
    }
}



