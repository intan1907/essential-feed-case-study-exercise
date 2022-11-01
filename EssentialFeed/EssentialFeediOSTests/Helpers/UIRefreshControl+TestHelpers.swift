//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit

extension UIRefreshControl {
    // iterate through all the targets and actions for the `.valueChanged` event in the refresh control and perform the action
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
