//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 02/11/22.
//

import EssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoaded: (([FeedImage]) -> Void)?
    
    var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoaded?(feed)
            }
            self?.isLoading = false
        }
    }
}
