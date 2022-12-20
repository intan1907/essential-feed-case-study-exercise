//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 06/11/22.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        return FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
