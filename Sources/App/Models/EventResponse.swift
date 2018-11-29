//
//  EventResponse.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation
import Vapor

struct EventResponse: Encodable, Content {
    
    let eventToken: Events<PostEvent>.Token
    let updates: [PostEvent]?
    
    init(token: Events<PostEvent>.Token?) {
        if let token = token,
            PostEvent.events.isValid(token: token) {
            updates = PostEvent.events.getEvents(since: token)
        } else {
            updates = nil
        }
        eventToken = PostEvent.events.lastId
    }
    
    init(update: PostEvent, token: Events<PostEvent>.Token) {
        self.eventToken = token
        self.updates = [update]
    }
}
