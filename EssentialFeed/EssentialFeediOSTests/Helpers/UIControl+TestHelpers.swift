//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit

extension UIControl {
    // iterate through all the targets and actions for the `event` event in the `UIControl` and perform the action
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
