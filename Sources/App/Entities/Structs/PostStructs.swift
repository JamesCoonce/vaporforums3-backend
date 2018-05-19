//
//  PostStructs.swift
//  App
//
//  Created by Stephen Bodnar on 5/9/18.
//

import Foundation
import Vapor

extension Post {
    
    struct AddPageViewRequest: Content {
        var id: Int
    }
    
    struct TutorialTypes {
        static let IntroToVapor = "IntroToVapor"
        static let Routing = "Routing"
        static let Other = "Other"
        static let JWT = "JSONWebToken"
    }
}

struct FormattedTutorialPost: Content {
    var id:Int?
    var postTitle: String
    let user_id: Int
    var viewCount: Int
    var isTutorial: Bool
    var tutorialType: String
    var isPublished: Bool
    var vaporVersion: Int
    var humanDate: String
    var synHiContent: String
}

struct PostWithoutContent: Content  {
    var id:Int?
    var postTitle: String
    let user_id: Int
    var viewCount: Int
    var isTutorial: Bool
    var tutorialType: String
    var isPublished: Bool
    var vaporVersion: Int
    var humanDate: String
}
