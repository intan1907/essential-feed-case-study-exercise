//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/11/22.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func retrieve() throws -> CachedFeed? {
        try performSync { context in
            // Result(caching:) akan otomatis melakukan do-catch block; Kalau masuk ke throws, maka otomatis akan di-passing ke failure. Jadi kita tinggal mendeklarasikan success block nya saja.
            Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            }
        }
    }
    
    public func deleteCachedFeed() throws {
        try performSync { context in
            Result {
                try ManagedCache.deleteCache(in: context)
            }
        }
    }
}
