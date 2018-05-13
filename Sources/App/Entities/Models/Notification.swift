//
//  Notification.swift
//  App
//
//  Created by Stephen Bodnar on 5/13/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Notification: PostgreSQLModel {
    
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
        let _ = try comment.post.get(on: request).map { post -> Post  in
            let userIdOfParentPost = post.user_id // id of user who created parent post
            let commentAuthor = comment.user_id // id of user who created the original comment which triggerd notification
            if commentAuthor != userIdOfParentPost { // only send if not the same. Don't send a notification to yourself
                sendNotificationToOriginalPostUser(with: userIdOfParentPost, andCommentId: id, using: request)
            }
            let commentsCommentId = comment.comment_id
            if commentsCommentId != nil {
                try sendNotificationToCommenter(replyingTo: commentsCommentId!, andUserIfOfParentPost: userIdOfParentPost, using: request, withCommentAuthor: commentAuthor, originalCommentId: id)
            }
            return post
        }
    }
    
    fileprivate static  func sendNotificationToOriginalPostUser(with userId: User.ID, andCommentId commentId: Comment.ID, using request: Request) {
        let notificationType = Comment.NotificationType.ReplyToPost
        let notification = Notification(userId: userId, commentId: commentId, type: notificationType, read: false)
        let _ = notification.save(on: request)
    }
    
    fileprivate static func sendNotificationToCommenter(replyingTo commentId: Int, andUserIfOfParentPost userIdOfParentPost: User.ID, using request: Request, withCommentAuthor commentAuthor: Int, originalCommentId id: Comment.ID) throws {
        let _ =  try Comment.find(commentId, on: request).map(to: Comment.self) { comment in
            guard let unwrappedComment = comment else { throw Abort.init(HTTPResponseStatus.notFound) }
            let _ = try unwrappedComment.author.get(on: request).map { authorOfComment in
                let authorOfCommentId = try authorOfComment.requireID()
                if (userIdOfParentPost != authorOfCommentId) && (commentAuthor != authorOfCommentId) {
                    let notification2 = Notification(userId: authorOfCommentId, commentId: id, type: Comment.NotificationType.ReplyToComment, read: false)
                    let _ = notification2.save(on: request)
                }
            }
            return unwrappedComment
        }
    }
    
}
