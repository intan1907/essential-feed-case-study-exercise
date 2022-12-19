//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 19/12/22.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        // table name
        let table = "Shared"
        
        // main presentation bundle where the localized table live
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) { }
    }
    
}
