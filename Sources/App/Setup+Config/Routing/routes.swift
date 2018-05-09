import Vapor
import Crypto
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let v1Api = V1ApiRoutes()
    try router.register(collection: v1Api)
    
}
