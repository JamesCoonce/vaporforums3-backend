import Vapor
import Crypto
import Authentication
import FluentPostgreSQL

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let v1Api = V1ApiRoutes()
    try router.register(collection: v1Api)
    
    let postController = PostController()
    router.get("/", use: postController.getFrontPage)
    
    router.get("login") { request -> Future<View> in
        return try request.view().render("login")
    }
    
    router.get("register") { request -> Future<View> in
        return try request.view().render("register")
    }
    
    router.get("tutorialCategories", String.parameter) { request -> Future<View> in
        let tutorialCategory = try request.parameters.next(String.self)
        return try Post.query(on: request).filter(\Post.tutorialType == tutorialCategory).descending().all().flatMap(to: View.self) { posts in
            let context =  PostListContext(posts: try posts.withNoContent())
            return try request.view().render("tutorialCategories", context)
        }
    }
    
    router.post("register") { request -> Future<Response> in
        return try request.content.decode(User.self).flatMap(to: Response.self) { user in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(email: user.email, displayName: user.displayName, password: passwordHashed)
            return newUser.save(on: request).flatMap(to: Response.self) { signedUpUser in
                let accessToken = try AccessToken.generateAccessToken(for: signedUpUser)
                return accessToken.save(on: request).map(to: Response.self) { token in
                    try request.session()["auth_token"] = token.token
                   return request.redirect(to: "/")
                }
            }
        }
    }
    
    router.get("showArticle", Int.parameter) { request -> Future<View> in
        let postId = try request.parameters.next(Int.self)
        return try Post.find(postId, on: request).flatMap(to: View.self) { post in
            guard let unwrappedPost = post else { throw Abort.init(HTTPResponseStatus.notFound) }
            let formattedPost = try unwrappedPost.convertToFormattedTutorialPost()
            let articleContext = ArticleListContext(article: formattedPost)
            return try request.view().render("showArticle", articleContext)
        }
    }
}
