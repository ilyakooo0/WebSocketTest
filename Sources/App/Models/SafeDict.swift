//
//  File.swift
//  App
//
//  Created by Ilya on 30/11/2018.
//

import Foundation

func getRandomNum(_ min: Int, _ max: Int) -> Int {
    #if os(Linux)
    return Int(random() % max) + min
    #else
    return Int(arc4random_uniform(UInt32(max)) + UInt32(min))
    #endif
}

struct SafeDict<Key: Hashable, Value> {
    private var queue = DispatchQueue(label: "soy.iko.safeDict.queue", attributes: .concurrent)
    
    private var dict = Dictionary<Key, Value>()
    
    subscript(_ key: Key) -> Value? {
        get {
            var out: Value?
            
            queue.sync {
                out = dict[key]
            }
            
            return out
        }
        
        set {
            queue.sync(flags: .barrier) {
                dict[key] = newValue
            }
        }
    }
    
    mutating func removeRandom() -> Key? {
        var key: Key?
        queue.sync(flags: .barrier) {
            if dict.count > 0 {
                key = Array(dict.keys)[getRandomNum(0, dict.count)]
                dict[key!] = nil
            }
        }
        return key
    }
    
    var count: Int {
        return dict.count
    }
    
    var values: Dictionary<Key, Value>.Values {
        return dict.values
    }
}
