//
//  PostStructs.swift
//  App
//
//  Created by Stephen Bodnar on 5/9/18.
//

import Foundation
import Vapor

extension Post {
    // This kind of post is used because we don't pass back the content
    // on the front page of the website yet
    struct PostWithoutContent {
        var id:Int?
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
    }
}
