//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 03/11/22.
//

import XCTest
@testable import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        // table name
        let table = "Feed"
        
        // main presentation bundle where the localized table live
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
}
