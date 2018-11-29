//
//  Post.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation
import Vapor

struct Post: Encodable, Content {
    typealias Id = Int
    let text: String
    let user: User.Id
    let id: Id = {
        lastId += 1
        return lastId
    }()
    
    private static var lastId = 0
    
    static var storage = SafeDict<Id, Post>()
}
