//
//  CacheFactory.swift
//

import Foundation

class CacheFactory {
    static var caches = [Cache]()

    static func addCache(_ cache: Cache) {
        caches.append(cache)
    }
    
    public static func getCache(forEntity name: String) -> Cache? {
        for cache in caches {
            if cache.isCacheForEntity(name: name) {
                return cache
            }
        }
        return nil
    }
}
