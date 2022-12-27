//
//  Paginated.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 26/12/22.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    // It's optional so that:
    // - "if we have the closure, then we can load more"
    // - "if we don't have the closure, then we can't load more"
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
