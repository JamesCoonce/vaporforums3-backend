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
        let postController = PostController()
        router.get("posts/latestFive", use: postController.getLatestFiveTutorials)
        
        // Declare Middlewares
        let adminMiddleware = AdminMiddleware()
        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware() // 1
        
        router.group(V1) { v1 in
            // Create Middleware groups
            let adminProtected = v1.grouped(adminMiddleware)
            let userAuthProtected = v1.grouped(tokenAuthenticationMiddleware)
            
            // UsersController
            let userController = UserController()
            v1.post("createUser", use: userController.createUser)
            v1.post("login", use: userController.loginUser)
            
            // PostController
           // let postController = PostController()
            adminProtected.post("createTutorial", use: postController.createTutorial)
            v1.get("getLatestFiveTutorials", use: postController.getLatestFiveTutorials)
            v1.post("addPageView", use: postController.addPageView)
            v1.get("showPost", Int.parameter, use: postController.showPost)
            
            let commentController = CommentController()
            let commentsForPostNesting = "post/comments"
            userAuthProtected.group(commentsForPostNesting) { authProtected in
                authProtected.post("create", use: commentController.createComment)
            }
        }
    }
}
