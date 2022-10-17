//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 18/10/22.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    // Don't Repeat Yourself (DRY) is a good principle, but not every code that looks alike is duplicate. Before deleting duplication, investigate if it's just an accidental duplication: code that seems the same but conceptually represents something else.
    // Mixing different concepts makes it harder to reason about separate parts of the system in isolation, increasing its complexity.
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        // This may look "duplicate," but it's an "accidental duplication."
        // Although we decided to keep the "Save" and "Load" methods in the same type (`LocalFeedLoader`), they belong to different contexts/Use Cases.
        XCTAssertEqual(store.receivedMessages, [])
        // By creating separate tests, if we ever decide to break those actions in separate types, it's much easier to do so. The tests are already separated and with all the necessary assertions.
    }

    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}
