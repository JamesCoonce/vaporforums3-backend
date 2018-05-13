//
//  CommentStructs.swift
//  App
//
//  Created by Stephen Bodnar on 5/13/18.
//

import Foundation
import Vapor

extension Comment {
    struct CreateCommentRequest: Content {
        var content: String
        var postId: Int
        var commentId: Int?
    }
}
