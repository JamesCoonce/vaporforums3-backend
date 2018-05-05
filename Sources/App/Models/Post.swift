//
//  Post.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

// extension Post: Migration {  }

extension Post: Content { }
extension Post: Timestampable {
    static var createdAtKey: WritableKeyPath<Post, Date?> {
        return \Post.created_at
    }
    
    static var updatedAtKey: WritableKeyPath<Post, Date?> {
        return \Post.updated_at
    }
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
    
    
}

