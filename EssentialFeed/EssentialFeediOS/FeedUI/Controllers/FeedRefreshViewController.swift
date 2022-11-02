//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    // since `target` action is based on old objective-C APIs, this controller needs to inherit from NSObject
    private(set) lazy var view = loadView()
    
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}
