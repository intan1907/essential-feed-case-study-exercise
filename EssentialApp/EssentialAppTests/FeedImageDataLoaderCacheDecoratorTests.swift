//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Intan Nurjanah on 19/11/22.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let (sut, loader, _) = makeSUT()
        let data = anyData()
        
        expect(sut, toCompleteWith: .success(data), when: {
            loader.complete(with: data)
        })
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader, _) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }
    
    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let (sut, loader, cache) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        let exp = expectation(description: "Waiting for load completion")
        _ = sut.loadImageData(from: url) { _ in exp.fulfill() }
        
        loader.complete(with: data)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(cache.messages, [.insert(data, url)], "Expected to cache loaded data on success")
    }
    
    func test_loadImageData_doesNotCacheOnLoaderFailure() {
        let (sut, loader, cache) = makeSUT()
        let url = anyURL()
        
        let exp = expectation(description: "Waiting for load completion")
        _ = sut.loadImageData(from: url) { _ in exp.fulfill() }
        
        loader.complete(with: anyNSError())
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache data on load error")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy, cache: CacheSpy) {
        let cache = CacheSpy()
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader, cache)
    }
    
    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed) ):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case insert(Data, URL)
        }
        
        func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.insert(data, url))
        }
    }
    
}
