//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Intan Nurjanah on 23/11/22.
//

import EssentialFeed

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            if let data = try? result.get() {
                self?.cache.insert(data, for: url) { _ in }
            }
            completion(result)
        }
    }
}
