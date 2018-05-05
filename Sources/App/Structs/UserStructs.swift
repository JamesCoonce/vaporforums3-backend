//
//  UserStructs.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor

struct AuthenticatedUser: Content {
    var email: String
    var user_id: Int
    var displayName: String
    var token: String
}

struct LoginRequest: Content {
    var email: String
    var password: String
}
