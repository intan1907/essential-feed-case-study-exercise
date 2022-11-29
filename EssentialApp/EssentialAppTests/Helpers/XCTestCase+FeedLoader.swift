//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Intan Nurjanah on 15/11/22.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase { }

// set this as a protocol extension so that other XCTestCase couldn't access this function
extension FeedLoaderTestCase {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed) ):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
