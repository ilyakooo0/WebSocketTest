import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("user", Int.parameter) { (req) -> User in
        let id = try req.parameters.next(Int.self)
        guard let user = User.storage[id] else {
            throw DatabaseError.notFound
        }
        return user
    }
    
    router.get("post", Int.parameter) { req -> Post in
        let id = try req.parameters.next(Int.self)
        guard let post = Post.storage[id] else {
            throw DatabaseError.notFound
        }
        return post
    }
    
    router.get("posts") { (req) -> [Post] in
        return Array(Post.storage.values)
    }
}

enum DatabaseError: Error, AbortError {
    var status: HTTPResponseStatus {
        return .notFound
    }
    
    var reason: String {
        return "Requested entry not found."
    }
    
    var identifier: String {
        return "Requested entry not found."
    }
        
    case notFound
}
