//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
    // since `target` action is based on old objective-C APIs, this controller needs to inherit from NSObject
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
