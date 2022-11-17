//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/11/22.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
