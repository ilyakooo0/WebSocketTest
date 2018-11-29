import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)

    let ws = NIOWebSocketServer.default()
    
    ws.get("test") { (ws, req) in
        ws.onText({ (ws, text) in
            ws.send("\(text) pong")
        })
    }
    
    ws.get("postUpdates", Int.parameter) { (ws, req) in
        let i = OpenSockets.insert(ws)
        ws.onClose.always {
            OpenSockets.remove(at: i)
        }
        let update = EventResponse(token: try! req.parameters.next(Int.self))
        ws.send(try! enc.encode(update))
    }
    
    ws.get("postUpdates") { (ws, req) in
        let i = OpenSockets.insert(ws)
        ws.onClose.always {
            OpenSockets.remove(at: i)
        }
        let update = EventResponse(token: nil)
        ws.send(try! enc.encode(update))
    }
    
    services.register(ws, as: WebSocketServer.self)
}
