//
//  Model.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation

struct Events<T> {
    private var buffer: CyclicBuffer<T>
    
    init(count: Int) {
        buffer = CyclicBuffer(count: count)
    }
    
    private(set) var lastId: Token = 0
    
    typealias Token = Int
    
    mutating func append(_ event: T) -> Token {
        lastId += 1
        
        buffer.append(event)
        
        return lastId
    }
    
    func getEvents(since id: Token) -> [T] {
        return buffer.getLast(count: lastId - id)
    }
    
    func isValid(token: Token) -> Bool {
        let dif = (lastId - token)
        return (dif < buffer.size) && (dif > 0)
    }
}
