//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/10/22.
//

import Foundation

// Rules and policies (e.g., validation logic) are better suited in a Domain Model that is application-agnostic (so it can be [re]used across applications).
private final class FeedCachePolicy {
    // The `currentDate` function is impure because everytime you invoke this function it may return a different value. It's non-deterministic.
    // It's easier to reason about core logic that is deterministic.
    private static let calendar = Calendar(identifier: .gregorian)
    
    // The initializers is private because `FeedCachePolicy` is a rule (value object: a model without identity), not a model with indentity. It just holds values, not a state.
    // So you can never have an instance of this.
    private init() { }
    // - entity -> model with identity -> have a state -> can be instantiate
    // - value object -> model without identity -> have no state -> can never be instantiated -> preferred to be static
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    // So we remove the `currentDate` function and deal only with values
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        // given date + max days
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}

// The `LocalFeedLoader` should encapsulate application-specific logic only, and communicate with Models to perform business logic.
public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}
 
extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed() { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, completion: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
 
extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case let .found(_, timestamp) where !FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in }
            case .empty, .found:
                // By using explicit "cases" instead of "default" we get a build error when a new case is added to the enum.
                // A build error can be useful as it will remind us to rethink the validation logic (maybe a new cache should also trigger a cache deletion!), but it makes our code less flexible (susceptible to breaking changes). It's trade-off.
                // Alternatively, you can add, along with the explicit cases "@unknown default" which will generate a warning (rather than a build error) when new cases are added
                break
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}
