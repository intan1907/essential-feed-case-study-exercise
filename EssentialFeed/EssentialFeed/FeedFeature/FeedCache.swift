//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/11/22.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
