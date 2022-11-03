//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 04/11/22.
//

import UIKit

// this is an Adapter pattern and it's a common pattern you will encounter on a composer
// when composing type, the Adapter pattern helps you connect unmatching APIs
// [FeedImage] -> Adapt -> [FeedImageCellController]
// to keep the responsibilities of creating the dependencies away from the types that uses the dependencies
final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map {
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: $0, imageLoader: imageLoader)
            let controller = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(controller),
                imageTransformer: UIImage.init
            )
            
            return controller
        }
    }
}
