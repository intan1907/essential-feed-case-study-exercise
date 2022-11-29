//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Intan Nurjanah on 15/11/22.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
