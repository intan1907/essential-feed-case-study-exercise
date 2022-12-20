//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 18/10/22.
//

import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(
        id: UUID(),
        description: "any description",
        location: "any location",
        url: anyURL()
    )
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
