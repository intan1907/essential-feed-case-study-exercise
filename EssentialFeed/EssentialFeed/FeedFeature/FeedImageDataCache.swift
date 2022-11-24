//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 24/11/22.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
