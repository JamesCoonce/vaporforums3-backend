//
//  Comment.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Comment: PostgreSQLModel {
    var id: Int?
    let content: String
    let user_id: Int
    let isCorrect: Bool
    let post_id: Int
    var comment_id: Int?
    var created_at: Date?
    var updated_at: Date?
    
    init(content: String, user_id: Int, isCorrect: Bool, post_id: Int, comment_id: Int?) {
        self.content = content
        self.user_id = user_id
        self.isCorrect = isCorrect
        self.post_id = post_id
        self.comment_id = comment_id
    }
}

extension Comment: Timestampable {
    static var createdAtKey: WritableKeyPath<Comment, Date?> { return \Comment.created_at }
    static var updatedAtKey: WritableKeyPath<Comment, Date?> { return \Comment.updated_at }
}

// Empty Migrations
extension Comment: Migration { }
extension Comment: Content { }
extension Comment: Parameter { }
