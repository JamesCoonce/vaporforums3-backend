//
//  APIController.swift
//  App
//
//  Created by Stephen Bodnar on 5/9/18.
//

import Foundation
import Vapor
import Crypto

class V1ApiRoutes: RouteCollection {
    let V1 = "v1"
    
    func boot(router: Router) throws {
        router.group(V1) { v1 in
            let userController = UserController()
            v1.post("createUser", use: userController.createUser)
            
            let middleWare = User.basicAuthMiddleware(using: BCryptDigest())
            let authedGroup = v1.grouped(middleWare)
            authedGroup.post("login", use: userController.loginUser)
            
            let postController = PostController()
            v1.post("createTutorial", use: postController.createTutorial)
        }
    }
}
