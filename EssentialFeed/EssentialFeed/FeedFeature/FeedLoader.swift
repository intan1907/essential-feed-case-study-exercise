//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 07/10/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
