//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 11/10/22.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        // make sure that the sut is deallocated after test finishes running
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
