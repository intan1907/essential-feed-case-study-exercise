//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 24/11/22.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
