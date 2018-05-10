//
//  AdminMiddleware.swift
//  App
//
//  Created by Stephen Bodnar on 5/10/18.
//

import Foundation
import Vapor

// Need to implement this soon
class AdminMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        return try next.respond(to: request)
    }
}
