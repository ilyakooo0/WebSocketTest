//
//  PostEvent.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation
import Vapor

enum PostEvent: Encodable, Content {
    init(from decoder: Decoder) throws {
        fatalError()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .added(let id):
            try container.encode(id, forKey: .added)
        case .deleted(let id):
            try container.encode(id, forKey: .deleted)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case added
        case deleted
    }
    
    public static var events = Events<PostEvent>(count: 1000)
    
    case added(Post.Id)
    case deleted(Post.Id)
}


