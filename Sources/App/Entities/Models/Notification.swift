//
//  Notification.swift
//  App
//
//  Created by Stephen Bodnar on 5/13/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

class Notification: PostgreSQLModel {
    
    var id: Int?
    var userId: User.ID // the userId of the person who will be getting the notificaton.
    var commentId: Comment.ID // the comment which created this notification
    var type: String
    var read: Bool
    
    init(userId: User.ID, commentId: Comment.ID, type: String, read: Bool) {
        self.userId = userId
        self.commentId = commentId
        self.type = type
        self.read = read
    }
    
    static func createNotification(from comment: Comment, withPostId postId: Post.ID, withRequest request: Request) throws {
        guard let id = comment.id else { throw Abort(.notFound, reason: "no comment id")}
        // in the case of replying to a post:
        // userId will be:
         try comment.post.get(on: request).map { post -> Post  in
            let userIdOfParentPost = post.user_id
            let commentAuthor = comment.user_id
            if commentAuthor != userIdOfParentPost {
                let notification = Notification(userId: userIdOfParentPost, type: Comment.NotificationType.ReplyToPost, commentId: id)
                try notification.save()
            }
            let commentsCommentId = comment.comment_id
            if commentsCommentId != nil {
                // if this is not nil, it means the comment is in reply to another comment
                // so, we need to send a notification
                // we need to get the commentId of the comment it is in reply to, and then find that comment
                // then find that author
                // then get their userId, and that is the value of userId here
                guard let userId2 = try Comment.find(commentsCommentId!)?.author.get()?.id! else { throw Abort(.badGateway, reason: "no userId for parent comment")}
                if (userIdOfParentPost != userId2) && (commentAuthor != userId2) {
                    let notification2 = Notification(userId: userId2, type: NotificationType.ReplyToComment, commentId: id)
                    try notification2.save()
                }
            }
        }
    }
}
