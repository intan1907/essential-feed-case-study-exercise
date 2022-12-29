//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/11/22.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
