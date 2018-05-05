import FluentSQLite
import Vapor
import FluentPostgreSQL
import Crypto

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
  //  try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
   
    
    try services.register(FluentPostgreSQLProvider())
    let psqlConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "anapaix", database: "vaporforums", password: nil)
    let database = PostgreSQLDatabase(config: psqlConfig)
    var dbConfig = DatabasesConfig()
    dbConfig.add(database: database, as: .psql)
    services.register(dbConfig)
    
    var migrations = MigrationConfig()
    services.register(migrations)
    
    Post.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
    User.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
    Comment.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
    // Configure a SQLite database
  /*  let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations) */

}

extension DatabaseIdentifier {
    /// Test database.
    static var vaporforums: DatabaseIdentifier<PostgreSQLDatabase> {
        return "vaporforums"
    }
}


