//
//  CommentController.swift
//  App
//
//  Created by Stephen Bodnar on 5/5/18.
//

import Foundation
import Vapor

final class CommentController {
    func createComment(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.content.decode(Comment.CreateCommentRequest.self).flatMap { commentRequest -> Future<Comment> in
            let newComment = Comment(content: commentRequest.content, user_id: 1, isCorrect: false, post_id: commentRequest.postId, comment_id: commentRequest.commentId)
            return newComment.save(on: request)
            }.transform(to: HTTPStatus.ok)
    }
}
