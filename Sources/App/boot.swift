import Vapor

struct OpenSockets {
    private(set) static var sockets = SafeDict<Int, WebSocket>()
    
    static func insert(_ socket: WebSocket) -> Int {
        let out = id
        id += 1
        sockets[out] = socket
        return out
    }
    
    static func remove(at id: Int) {
        sockets[id] = nil
    }
    
    
    private static var id = 0
}


let enc: JSONEncoder = {
    var out = JSONEncoder()
    return out
}()

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let akakiy = User(name: User.Name(first: "Акакий", second: "Программистович"))
    User.storage[akakiy.id] = akakiy
    
    app.eventLoop.scheduleRepeatedTask(initialDelay: .seconds(10), delay: .seconds(10)) { (task: RepeatedTask) in
        let _ = try app.client().get("https://baconipsum.com/api/?type=all-meat&paras=1&start-with-lorem=0")
            .flatMap { try $0.content.decode([String].self) }
            .do { (texts) in
                guard let text = texts.first else { return }
                
                let p = Post.init(text: text, user: akakiy.id)
                
                Post.storage[p.id] = p
                
                let event = PostEvent.added(p.id)
                let t = PostEvent.events.append(event)
                
                OpenSockets.sockets.values.forEach { (ws: WebSocket) in
                    ws.send(try! enc.encode(EventResponse(update: event, token: t)))
                }
        }
    }
    
    let _ = app.eventLoop.scheduleRepeatedTask(initialDelay: .seconds(205), delay: .seconds(10)) { (task: RepeatedTask) throws -> Void in
        if (Post.storage.count > 20) {
            if let key = Post.storage.removeRandom() {
                let event = PostEvent.deleted(key)
                let t = PostEvent.events.append(event)
                OpenSockets.sockets.values.forEach { (ws: WebSocket) in
                    ws.send(try! enc.encode(EventResponse(update: event, token: t)))
                }
            }
        }
        
        return
    }
}
