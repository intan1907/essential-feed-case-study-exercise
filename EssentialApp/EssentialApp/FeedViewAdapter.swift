//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 04/11/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

// this is an Adapter pattern and it's a common pattern you will encounter on a composer
// when composing type, the Adapter pattern helps you connect unmatching APIs
// [FeedImage] -> Adapt -> [FeedImageCellController]
// to keep the responsibilities of creating the dependencies away from the types that uses the dependencies
final class FeedViewAdapter: ResourceView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map {
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: $0, imageLoader: imageLoader)
            let controller = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(controller),
                imageTransformer: UIImage.init
            )
            
            return controller
        })
    }
}
