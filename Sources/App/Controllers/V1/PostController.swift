//
//  PostController.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
final class PostController {
    func createTutorial(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.content.decode(Post.self).flatMap { newPost in
            return newPost.save(on: request).transform(to: HTTPStatus.ok)
        }
    }
    
    func getLatestFiveTutorials(_ request: Request) throws -> Future<[Post]> {
        let queryField = QueryField(name: "created_at") // 1
        let querySort = QuerySort(field: queryField, direction: QuerySortDirection.descending) // 2
        return try Post.query(on: request).filter(\Post.isPublished == true).filter(\Post.isTutorial == true).sort(querySort).range(lower: 0, upper: 5).all()
    }
}
