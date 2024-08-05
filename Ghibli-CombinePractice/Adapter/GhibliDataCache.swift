//
//  GhibliDataCache.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/21/24.
//

import Foundation

enum GetCacheKey {
    case film
}

protocol GhibliDataCacheProtocol {
    func save(object: AnyObject, forKey key: String) async
    func get(forKey key: String) async -> AnyObject?
}

actor GhibliDataCache: GhibliDataCacheProtocol {
    static let shared = GhibliDataCache()
    private let cache = NSCache<NSString, AnyObject>()
    
    func save(object: AnyObject, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> AnyObject? {
        cache.object(forKey: key as NSString)
    }
}
