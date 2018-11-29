//
//  User.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation
import Vapor

struct User: Encodable, Content {
    struct Name: Content {
        let first: String
        let second: String
    }
    
    typealias Id = Int
    
    let name: Name
    let id: Id = {
        lastID += 1
        return lastID
    }()
    
    static var storage = SafeDict<Id, User>()
    
    private static var lastID = 0
}
