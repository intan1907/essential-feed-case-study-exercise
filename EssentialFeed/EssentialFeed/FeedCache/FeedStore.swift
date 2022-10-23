//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/10/22.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

// To decouple the application from framework details, we don't let frameworks dictate the Use Case interface (e.g., adding Codable requirements or CoreData managed contexts parameters).
// We do so by test-driving the interfaces the Use Case needs for its collaborators, rather than defining the interface upfront to facilitate a specific framework implementation.
public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}

/*
 FeedStore implementation inbox:
 - Insert
     - To empty cache works
     - To non-empty cache overrides previous value
     - Error (if possible to simulate, e.g., no write permission)

 - Retrieve
     - Empty cache works (before something is inserted)
     - Non-empty cache returns data
     - Non-empty cache twice returns same data (retrieve should have no side-effects)
     - Error (if possible to simulate, e.g., invalid data)

 - Delete
     - Empty cache does nothing (cache stays empty and does not fail)
     - Inserted data leaves cache empty
     - Error (if possible to simulate, e.g., no write permission)

 - Side-effects must run serially to avoid race-conditions (deleting the wrong cache... overriding the latest data...)
 */
