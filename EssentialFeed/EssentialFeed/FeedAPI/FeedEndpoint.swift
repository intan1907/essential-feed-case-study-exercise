//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 23/12/22.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
