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
    let forbiddenError =  Abort.init(HTTPResponseStatus.forbidden)
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        if let authTokenString = request.http.headers.firstValue(name: HTTPHeaderName("Authorization")) {
            let futureAccessToken = try AccessToken.query(on: request).filter(\AccessToken.token == authTokenString).first()
            return futureAccessToken.flatMap(to: Response.self) { token in
                guard let unwrappedToken = token else { throw self.forbiddenError }
                if unwrappedToken.role == User.Role.admin { return try next.respond(to: request) }
                else { throw  self.forbiddenError}
            }
        } else { throw forbiddenError }
    }
}
