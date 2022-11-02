//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 01/11/22.
//

import EssentialFeed

public final class FeedUIComposer {
    private init() { }
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    // this is an Adapter pattern and it's a common pattern you will encounter on a composer
    // when composing type, the Adapter pattern helps you connect unmatching APIs
    // [FeedImage] -> Adapt -> [FeedImageCellController]
    // to keep the responsibilities of creating the dependencies away from the types that uses the dependencies
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> (([FeedImage]) -> Void) {
        return { [weak controller] feed in
            controller?.tableModel = feed.map {
                FeedImageCellController(viewModel: FeedImageViewModel(model: $0, imageLoader: loader))
            }
        }
    }
}
