//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Intan Nurjanah on 27/10/22.
//

import XCTest

final class FeedViewController {
    
    init(loader: FeedViewControllerTests.FeedLoaderSpy) {
        
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = FeedLoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: Loader
    
    class FeedLoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
    
}
