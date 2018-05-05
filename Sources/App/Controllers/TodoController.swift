import Vapor

/// Controlers basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }
    
    func rrrrr(_ req: Request) throws -> Future<Post> {
        let post = Post(content: "this is content", postTitle: "this is a title. vapor 3 hello!", user_id: 1, viewCount: 23, isTutorial: true, tutorialType: "IntroToVapor", isPublished: false, vaporVersion: 2, synHiContent: "----")
        return post.save(on: req)
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}

import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?
    
    /// A title describing what this `Todo` entails.
    var title: String
    
    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }
