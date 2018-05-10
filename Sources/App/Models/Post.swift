//
//  Post.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

extension Post: Content { }
extension Post: Timestampable {
    static var createdAtKey: WritableKeyPath<Post, Date?> { return \Post.createdAt }
    static var updatedAtKey: WritableKeyPath<Post, Date?> { return \Post.updatedAt }
}

final class Post: PostgreSQLModel {
    
    var id:Int?
    var content: String
    var postTitle: String
    let user_id: Int
    var viewCount: Int
    var isTutorial: Bool
    var tutorialType: String
    var isPublished: Bool
    var vaporVersion: Int
    var synHiContent: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(content: String, postTitle: String, user_id: Int, viewCount: Int, isTutorial: Bool, tutorialType: String, isPublished: Bool, vaporVersion: Int, synHiContent: String) {
        self.content = content
        self.postTitle = postTitle
        self.user_id = user_id
        self.viewCount = viewCount
        self.isTutorial = isTutorial
        self.tutorialType = tutorialType
        self.isPublished = isPublished
        self.vaporVersion = vaporVersion
        self.synHiContent = synHiContent
    }
    
    fileprivate func createPostWithNoContent() throws -> Post.PostWithoutContent {
        guard let syntaxHilightedContent = synHiContent, let created = createdAt,  let updated = updatedAt else { throw Abort.init(HTTPResponseStatus.notFound) }
        return try Post.PostWithoutContent(id: self.requireID(), postTitle: self.postTitle, user_id: user_id, viewCount: viewCount, isTutorial: isTutorial, tutorialType: tutorialType, isPublished: isPublished, vaporVersion: vaporVersion, synHiContent: syntaxHilightedContent, createdAt: created, updatedAt: updated)
    }
}

extension Array where Element:Post {
    func withNoContent() throws -> [Post.PostWithoutContent]  {
        var postsWithOutContentField = [Post.PostWithoutContent]()
        for post in self { try postsWithOutContentField.append(post.createPostWithNoContent()) }
        return postsWithOutContentField
    }
}

