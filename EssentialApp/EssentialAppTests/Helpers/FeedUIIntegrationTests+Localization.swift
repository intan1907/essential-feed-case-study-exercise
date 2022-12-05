//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 03/11/22.
//

import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        // `localizedString` parameters:
        // - key: the key
        // - value: default value if the desired value not found. If `nil`, it will give the `key` as the default value
        // - table: `.strings` file name that will be the place to search on. If `nil`, it will search on all table
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
