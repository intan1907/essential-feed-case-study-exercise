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

    private class FeedStoreSpy: FeedStore {
        enum ReceivedMessage: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        
        // `deleteCachedFeedCallCount` dan `insertions` dihapus dan disatukan ke array `ReceivedMessage` agar bisa dibuat ke satu array untuk kita bisa memeriksa urutan dari pemanggilan fungsi delete/insert nya.
        private(set) var receivedMessages = [ReceivedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedFeed)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(feed, timestamp))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
    
}
