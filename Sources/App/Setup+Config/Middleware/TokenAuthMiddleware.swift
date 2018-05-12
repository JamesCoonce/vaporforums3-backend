//
//  TokenAuthMiddleware.swift
//  App
//
//  Created by Stephen Bodnar on 5/10/18.
//

import Foundation
import Vapor

class TokenAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        if let authToken = request.http.headers.firstValue(name: HTTPHeaderName("Authorization")) {
            print("the authToken is \(authToken)")
        }
        return try next.respond(to: request)
    }
}
