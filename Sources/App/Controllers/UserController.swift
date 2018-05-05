//
//  UserController.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import Crypto

final class UserController {
    
    func createUser(_ request: Request) throws -> Future<AuthenticatedUser> {
        let user = try request.content.decode(User.self)
        return user.flatMap(to: AuthenticatedUser.self) { (user) -> Future<AuthenticatedUser> in
            let newUser = try user.newUserWithHashedPassword()
            return newUser.save(on: request).map(to: AuthenticatedUser.self) { authedUser in
                return AuthenticatedUser(email: authedUser.email, user_id: authedUser.id!, displayName: authedUser.displayName, token: "token here")
            }
        }
    }
    
    func loginUser(_ request: Request) throws -> Future<AuthenticatedUser> {
        let loginRequest = try request.content.decode(LoginRequest.self)
    }
}

