//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/10/22.
//

import Foundation

// Rules and policies (e.g., validation logic) are better suited in a Domain Model that is application-agnostic (so it can be [re]used across applications).
private final class FeedCachePolicy {
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    init(currentDate: @escaping () -> Date) {
        self.currentDate = currentDate
    }
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    func validate(_ timestamp: Date) -> Bool {
        // given date + max days
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
}

// The `LocalFeedLoader` should encapsulate application-specific logic only, and communicate with Models to perform business logic.
public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let cachePolicy: FeedCachePolicy
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
        self.cachePolicy = FeedCachePolicy(currentDate: currentDate)
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
            case let .found(feed, timestamp) where self.cachePolicy.validate(timestamp):
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
            case let .found(_, timestamp) where !self.cachePolicy.validate(timestamp):
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
