//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    // since `target` action is based on old objective-C APIs, this controller needs to inherit from NSObject
    private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        // onChange closure ini adalah binding logic antara ViewModel dan View
        // binding (state di) ViewModel dengan View
        viewModel.onChange = { viewModel in
            if viewModel.isLoading {
                view.beginRefreshing()
            } else {
                view.endRefreshing()
            }
        }
        // binding View dengan (aksinya yang ada di) ViewModel
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}
