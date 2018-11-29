//
//  CyclicBuffer.swift
//  App
//
//  Created by Ilya on 29/11/2018.
//

import Foundation

struct CyclicBuffer<T> {
    private var buffer: [T?]
    private var index = 0
    let size: Int
    
    init(count: Int) {
        buffer = Array(repeating: nil, count: count)
        size = count
    }
    
    private let queue = DispatchQueue(label: "soy.iko.cyclicBufferqueue", attributes: DispatchQueue.Attributes.concurrent)
    
    mutating func append(_ element: T) {
        queue.sync(flags: .barrier) {
            self.buffer[self.index] = element
            self.index = (self.index + 1) % self.size
        }
    }
    
    func getLast(count: Int = 1) -> [T] {
        var out: [T] = []
        
        queue.sync {
            out = Array((buffer[index..<size] + buffer[0..<index]).lazy
                .compactMap {$0}
                .suffix(count))
        }
        
        return out
    }
}
