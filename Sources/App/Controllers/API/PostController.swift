//
//  PostController.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Leaf

struct PostContext: Content {
    let posts: [Post.PostWithoutContent]
}

final class PostController {
    func getFrontPage(_ request: Request) throws -> Future<View> {
       // let queryField = QueryField(name: "created_at")
       // let querySort = QuerySort(field: queryField, direction: QuerySortDirection.descending)
        return Post.query(on: request).all().flatMap(to: View.self) { posts in
            let postsWithoutContent = try posts.withNoContent()
            let context = PostContext(posts: postsWithoutContent)
            return try request.view().render("homePage", context)
        }
    }
    
    func createTutorial(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.content.decode(Post.self).flatMap { newPost in
            return newPost.save(on: request).transform(to: HTTPStatus.ok)
        }
    }
    
    func getLatestFiveTutorials(_ request: Request) throws -> Future<[Post.PostWithoutContent]> {
        let queryField = QueryField(name: "created_at")
        let querySort = QuerySort(field: queryField, direction: QuerySortDirection.descending)
        return try Post.query(on: request).filter(\Post.isPublished == true).filter(\Post.isTutorial == true).sort(querySort).range(lower: 0, upper: 5).all().map(to: [Post.PostWithoutContent].self, { (posts) in
            return try posts.withNoContent()
        })
    }
    
    // this function edits our post object to increment the viewCount by 1
    func addPageView(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.content.decode(Post.AddPageViewRequest.self).flatMap { addViewCountRequest in
            try Post.find(addViewCountRequest.id, on: request).flatMap(to: Post.self) { post in
                guard let unwrappedPost = post else { throw Abort.init(HTTPResponseStatus.notFound) }
                let newViewCount = unwrappedPost.viewCount + 1
                unwrappedPost.viewCount = newViewCount
                return unwrappedPost.save(on: request)
            }
        }.transform(to: HTTPStatus.ok)
    }
    
    func showPost(_ request: Request) throws -> Future<Post> {
        let postId = try request.parameters.next(Int.self)
        return try Post.find(postId, on: request).map(to: Post.self) { post in
            guard let post = post else { throw Abort.init(HTTPStatus.notFound) }
            return post
        }
    }
    
}
