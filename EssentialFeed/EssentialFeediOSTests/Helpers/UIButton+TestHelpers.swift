//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
