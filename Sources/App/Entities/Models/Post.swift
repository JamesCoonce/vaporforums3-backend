//
//  Post.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

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
    var created_at: Date?
    var updated_at: Date?
    
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
    
    fileprivate func createPostWithNoContent() throws -> PostWithoutContent {
        guard let created = created_at else { throw Abort.init(HTTPResponseStatus.notFound) }
        let postWithoutContent = try PostWithoutContent(id: self.requireID(), postTitle: self.postTitle, user_id: self.user_id, viewCount: self.viewCount, isTutorial: self.isTutorial, tutorialType: self.tutorialType, isPublished: self.isPublished, vaporVersion: self.vaporVersion, humanDate: Helpers.humanDate(from: created))
        return postWithoutContent
    }
    
    func convertToFormattedTutorialPost() throws -> FormattedTutorialPost {
        guard let created = created_at else { throw Abort.init(HTTPResponseStatus.notFound) }
        guard let content = synHiContent else { throw Abort.init(HTTPResponseStatus.notFound) }
        let formattedPost = try FormattedTutorialPost(id: self.requireID(), postTitle: self.postTitle, user_id: self.user_id, viewCount: self.viewCount, isTutorial: self.isTutorial, tutorialType: self.tutorialType, isPublished: self.isPublished, vaporVersion: self.vaporVersion, humanDate: Helpers.humanDate(from: created), synHiContent: content)
        return formattedPost
    }
}

extension Post: Timestampable {
    static var createdAtKey: WritableKeyPath<Post, Date?> { return \Post.created_at }
    static var updatedAtKey: WritableKeyPath<Post, Date?> { return \Post.updated_at }
}

extension Array where Element:Post {
    func withNoContent() throws -> [PostWithoutContent]  {
        var postsWithOutContentField = [PostWithoutContent]()
        for post in self { try postsWithOutContentField.append(post.createPostWithNoContent()) }
        return postsWithOutContentField
    }
}

// Empty Extension
extension Post: Content { }
extension Post: Migration { }

