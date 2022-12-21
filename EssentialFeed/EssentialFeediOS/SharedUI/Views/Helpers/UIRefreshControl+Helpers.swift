//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 05/11/22.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
