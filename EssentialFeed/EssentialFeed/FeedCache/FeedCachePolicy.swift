//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 19/10/22.
//

import Foundation

// Rules and policies (e.g., validation logic) are better suited in a Domain Model that is application-agnostic (so it can be [re]used across applications).
final class FeedCachePolicy {
    // The `currentDate` function is impure because everytime you invoke this function it may return a different value. It's non-deterministic.
    // It's easier to reason about core logic that is deterministic.
    private static let calendar = Calendar(identifier: .gregorian)
    
    // I.S: kalau ini struct/class
    // The initializers is private because `FeedCachePolicy` is a rule (value object: a model without identity), not a model with indentity. It just holds values, not a state.
    // So you can never have an instance of this.
    private init() { } // -> enum tanpa case juga tidak butuh initializers
    // - entity -> model with identity -> have a state -> can be instantiate
    // - value object -> model without identity -> have no state -> can never be instantiated -> preferred to be static and being a struct/enum without cases (tidak butuh jadi class karena tidak punya state)
    
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
