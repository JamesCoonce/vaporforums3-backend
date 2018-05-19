import Vapor
import Crypto
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let v1Api = V1ApiRoutes()
    try router.register(collection: v1Api)
    
    let postController = PostController()
    router.get("homePage", use: postController.getFrontPage)
    
    router.get("showArticle", Int.parameter) { request -> Future<View> in
        let postId = try request.parameters.next(Int.self)
        return try Post.find(postId, on: request).flatMap(to: View.self) { post in
            guard let unwrappedPost = post else { throw Abort.init(HTTPResponseStatus.notFound) }
            let articleContext = ArticleListContext(article: unwrappedPost)
            return try request.view().render("showArticle", articleContext)
        }
    }
}
