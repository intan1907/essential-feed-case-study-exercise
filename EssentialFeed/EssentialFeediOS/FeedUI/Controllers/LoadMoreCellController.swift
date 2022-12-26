//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 26/12/22.
//

import UIKit
import EssentialFeed

public final class LoadMoreCellController: NSObject, UITableViewDataSource {
    private let cell = LoadMoreCell()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We don't need to reuse the cell because it's only one cell in the view
        cell
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: EssentialFeed.ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
}
