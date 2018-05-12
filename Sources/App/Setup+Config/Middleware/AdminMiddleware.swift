//
//  AdminMiddleware.swift
//  App
//
//  Created by Stephen Bodnar on 5/10/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
// Need to implement this soon
class AdminMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        if let authToken = request.http.headers.firstValue(name: HTTPHeaderName("Authorization")) {
            let futureAccessToken = try AccessToken.query(on: request).filter(\AccessToken.token == authToken).first()
            return futureAccessToken.flatMap(to: Response.self) { token in
                guard let unwrappedToken = token else { throw Abort.init(HTTPResponseStatus.forbidden) }
                if unwrappedToken.role == User.Role.admin { return try next.respond(to: request) }
                else { throw Abort.init(HTTPResponseStatus.forbidden) }
            }
        }
        throw Abort.init(HTTPResponseStatus.forbidden)
    }
}
