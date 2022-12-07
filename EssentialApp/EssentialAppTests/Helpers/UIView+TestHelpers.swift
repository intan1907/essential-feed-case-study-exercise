//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Intan Nurjanah on 07/12/22.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
