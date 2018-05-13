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
    
    // the comment here is the comment that is posted and initiates a new notificaiton being send
    // the postId is the id of the post that the comment was made on
    static func createNotification(from comment: Comment, withPostId postId: Post.ID, withRequest request: Request) throws {
         let id = try comment.requireID()
        // in the case of replying to a post:
        // userId will be:
        let _ = try comment.post.get(on: request).map { post -> Post  in
            let userIdOfParentPost = post.user_id // id of user who created parent post
            let commentAuthor = comment.user_id // id of user who created the original comment which triggerd notification
            if commentAuthor != userIdOfParentPost { // only send if not the same. Don't send a notification to yourself
                let notification = Notification(userId: userIdOfParentPost, commentId: id, type: Comment.NotificationType.ReplyToPost, read: false)
                let _ = notification.save(on: request)
            }
            let commentsCommentId = comment.comment_id
            if commentsCommentId != nil {
                // if this is not nil, it means the comment is in reply to another comment
                // so, we need to send a notification
                // we need to get the commentId of the comment it is in reply to, and then find that comment
                // then find that author
                // then get their userId, and that is the value of userId here
                let _ =  try Comment.find(commentsCommentId!, on: request).map(to: Comment.self) { comment in
                    guard let unwrappedComment = comment else { Abort.init(HTTPResponseStatus.notFound) }
                    let _ = try unwrappedComment.author.get(on: request).map { authorOfComment in
                        let authorOfCommentId = try authorOfComment.requireID()
                        if (userIdOfParentPost != authorOfCommentId) && (commentAuthor != authorOfCommentId) {
                            let notification2 = Notification(userId: authorOfCommentId, commentId: id, type: Comment.NotificationType.ReplyToComment, read: false)
                            let _ = notification2.save(on: request)
                        }
                    }
                }
            }
        }
    }
}
