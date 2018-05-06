import Vapor
import Crypto
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "hello world"
    }
    

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.get("misty", use: todoController.rrrrr)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    
    let userController = UserController()
    router.post("createUser", use: userController.createUser)
    let middleWare = User.basicAuthMiddleware(using: BCryptDigest())
    let authedGroup = router.grouped(middleWare)
    authedGroup.post("login", use: userController.loginUser)
    
}
