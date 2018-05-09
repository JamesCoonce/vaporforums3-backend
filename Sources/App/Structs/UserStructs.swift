//
//  UserStructs.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor

extension User {
    struct AuthenticatedUser: Content {
        var email: String
        var id: Int
        var displayName: String
        var token: String
    }
    
    struct LoginRequest: Content {
        var email: String
        var password: String
    }
    
    struct PublicUser: Content {
        var email: String
        var id: Int
        var displayName: String
    }
}

